table 21001401 "_Заказ Ресторана Строка"
{
    // version KRF,MBR CHECK010420

    // yuri > 28.05.13 + Dim8 Консал. Ед.
    // apik 251214 (91420) Наследование поля Dim3 (код объекта) из меню
    // apik 280415 (104159) добавлена логика фиксированных ЕКТУ
    // VAN 130115 Добавлено поле "Питание Подробно Строка Но."
    // apik 200716 (164579) +опции в поле Причина Отмены
    // apik 200716 (164531) скидки
    //         ЗаказРесторанаСтрока."Цена Единицы" := D;
    //         ЗаказРесторанаСтрока.VALIDATE(Сумма, ROUND(_КолвоБлюда * D,0.01));
    //         ЗаказРесторанаСтрока.ClubBonusPrice := ConvBonusKCY(ЗаказРесторанаСтрока."Цена Единицы",TODAY);
    //         ЗаказРесторанаСтрока.ClubBonusPriceSumm := ConvBonusKCY(ЗаказРесторанаСтрока.Сумма,TODAY);

    DataPerCompany = false;
    DrillDownPageID = "_Заказ Ресторана Просм. Строка";
    LookupPageID = "_Заказ Ресторана Просм. Строка";

    fields
    {
        field(1;"Заказ Но.";Code[20])
        {
        }
        field(2;"Код Блюда";Code[10])
        {
            TableRelation = IF ("Тип позиции"=CONST("Товар")) Item
                            ELSE IF ("Тип позиции"=CONST("Ресурс")) Resource;

            trigger OnValidate()
            begin
                Clear("Менеджер Группа Классификации");
                if Блюда.Get("Код Блюда") then begin
                  "Ресторан Блюдо Но." := Блюда."Ресторан Блюдо Но.";
                  if Название = '' then
                    Название := Блюда.Description;   //если пустое - перезаписываем
                  "Код Единицы Измерения" := Блюда."Base Unit of Measure";
                  "Менеджер Группа Классификации" := Блюда."Менеджер Группа Классификации";
                end;

                ЗаказРесторанаЗаголовок.Reset;
                ЗаказРесторанаЗаголовок.SetRange("Заказ Но.","Заказ Но.");
                if ЗаказРесторанаЗаголовок.FindFirst then begin
                  УчтМенюСтрока.Reset;
                  УчтМенюСтрока.SetRange("Документ Но.","Меню Но.");
                  УчтМенюСтрока.SetRange("Товар Но.","Код Блюда");
                  УчтМенюСтрока.SetRange("Строка Но.","Номер Позиции В Меню");
                  УчтМенюСтрока.SetRange(Блокировано, false);
                  if not УчтМенюСтрока.FindLast then
                    УчтМенюСтрока.SetRange("Строка Но.");
                  if УчтМенюСтрока.FindLast then begin
                    "Цена Единицы" := УчтМенюСтрока."Цена Продажи Руб";
                    Сумма := УчтМенюСтрока."Цена Продажи Руб";
                    "Код Единицы Измерения" := УчтМенюСтрока."Код Единицы Измерения";
                    Название := УчтМенюСтрока."Блюдо Название";
                  end;

                if "Дата Заказа" = 0D then
                  "Дата Заказа" := WorkDate;
                if "Время Заказа" = 0T then
                  "Время Заказа" := Time;
                  "Код Отдела Блюда" := ЗаказРесторанаЗаголовок."Код Отдела";
                  if (ЗаказРесторанаЗаголовок."Дата Начала Заказа" = 0D) then begin
                    ЗаказРесторанаЗаголовок."Дата Начала Заказа" := WorkDate;
                    ЗаказРесторанаЗаголовок."Время Начала Заказа" := Time;
                  end;
                  if ЗаказРесторанаЗаголовок."Дата Окончания Заказа" <> WorkDate then
                    ЗаказРесторанаЗаголовок."Дата Окончания Заказа" := WorkDate;
                  ЗаказРесторанаЗаголовок."Время Окончания Заказа" := Time;
                  ЗаказРесторанаЗаголовок.Modify;

                  if "Код Зала Продажи" = '' then
                    "Код Зала Продажи" := ЗаказРесторанаЗаголовок."Код Зала Продажи";
                  DiscountMgt.FindDisc(CreateDateTime("Дата Заказа","Время Заказа"),Rec);
                  if "Discount Code" <> '' then
                    if DiscountCode.Get("Discount Code") then
                     if DiscountCode."Price Change" then begin
                      RoundIt := RoundMethod.Get(DiscountCode."Rounding Method");
                      DiscAmount := "Цена Единицы" * "Discount %" / 100;
                      "Цена Единицы" -= DiscAmount;
                      if RoundIt then
                        "Цена Единицы" := RoundMethod.RoundAmount("Цена Единицы");
                      if "Цена Единицы" < 0 then
                        "Цена Единицы" := 0;
                     end;
                  Validate("Цена Единицы");
                end;
            end;
        }
        field(3;"Название";Text[30])
        {
            FieldClass = Normal;
        }
        field(4;"Название 2";Text[30])
        {
            CalcFormula = Lookup(Item."Description 2" WHERE ("No."=FIELD("Заказ Но.")));
            FieldClass = FlowField;
        }
        field(5;"Количество";Decimal)
        {
            DecimalPlaces = 0:6;

            trigger OnValidate()
            begin
                Количество := Round(Количество,0.001);
                //apik VALIDATE(Сумма);
                //apik 200716 (164531) > скидки
                UpdateAmounts;
                //apik 200716 (164531) < скидки
            end;
        }
        field(6;"Сумма";Decimal)
        {

            trigger OnValidate()
            begin
                //Сумма := ROUND("Цена Единицы" * Количество,0.01);
                //ClubBonusPriceSumm := ROUND(Количество * ClubBonusPrice,0.01);
            end;
        }
        field(7;"Строка Но.";Integer)
        {
            InitValue = 0;
        }
        field(8;"Цена Единицы";Decimal)
        {

            trigger OnValidate()
            begin
                //apik VALIDATE(Сумма);
                //apik 200716 (164531) > скидки
                GetGSetup;
                ClubBonusPrice := ConvBonusKCY("Цена Единицы",Today);
                UpdateAmounts;
                //apik 200716 (164531) < скидки
            end;
        }
        field(9;"Внешний Заказ Но.";Code[20])
        {
        }
        field(10;"Статус Блюда";Option)
        {
            OptionMembers = "Заказано","Отменено","Перемещено","Выбрано";
        }
        field(11;"Причина Списания";Option)
        {
            OptionMembers = " ","Списание","Возврат","Ошибка Официанта","ваучер";
        }
        field(12;"Время Отмены Блюда";Time)
        {
        }
        field(13;"Менеджер Отмена Но.";Code[10])
        {
        }
        field(14;"Менеджер Разделение Но.";Code[10])
        {
        }
        field(15;"Менеджер Изменение Гостей Но.";Code[10])
        {
        }
        field(16;"Менеджер Смена Официанта Но.";Code[10])
        {
        }
        field(17;"Менеджер Переноса на Др. Стол";Code[10])
        {
        }
        field(18;"Менеджер Блюда Откр. Цена";Code[10])
        {
        }
        field(19;"Причина Отмены";Option)
        {
            OptionCaption = 'Отказ Клиента,Ошибка Официанта,Ошибка Повара,Долгое Приготовление,Стоп-Лист,Гость Изменил Заказ,Перебито По Сервис Меню,Перебито По Обычному Меню,Слив остатков,Промывка системы,Сбой пролайна,Тест';
            OptionMembers = "Отказ Клиента","Ошибка Официанта","Ошибка Повара","Долгое Приготовление","Стоп-Лист","Гость Изменил Заказ","Перебито По Сервис Меню","Перебито По Обычному Меню","Слив остатков","Промывка системы","Сбой пролайна","Тест";
        }
        field(20;"Код Единицы Измерения";Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(21;"Ресторан Блюдо Но.";Text[4])
        {
        }
        field(22;"Смена Принтера";Integer)
        {
        }
        field(23;"Дата Заказа";Date)
        {
        }
        field(24;"Время Заказа";Time)
        {
        }
        field(25;"Дата Оплаты";Date)
        {
        }
        field(26;"Время Оплаты";Time)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(1000;"Код Зала Приготовления";Code[10])
        {
            TableRelation = "KR Hall";

            trigger OnValidate()
            begin
                Validate("Код Зала Продажи","Код Зала Приготовления");
            end;
        }
        field(1001;"Бронирование Но.";Code[20])
        {
            CalcFormula = Lookup("_Учт. Заказ Ресторана Заголово"."Бронирование Но." WHERE ("Заказ Но."=FIELD("Заказ Но.")));
            FieldClass = FlowField;
        }
        field(1002;"Комната Но.";Code[10])
        {
            CalcFormula = Lookup("_Учт. Заказ Ресторана Заголово"."Комната Гостя Но." WHERE ("Заказ Но."=FIELD("Заказ Но.")));
            FieldClass = FlowField;
        }
        field(50010;"Код Отдела Блюда";Code[10])
        {
        }
        field(50011;"Код Проекта Блюда";Code[10])
        {
        }
        field(50012;"Код Зала Продажи";Code[10])
        {
            TableRelation = "KR Hall";

            trigger OnValidate()
            begin
                if not РесторанЗалы.Get("Код Зала Продажи") then
                  Clear(РесторанЗалы);

                //yuri 160715
                "Sales Company" := РесторанЗалы.GetSalesCompany;
            end;
        }
        field(50016;"Перенесено Из Другой Смены";Boolean)
        {
            InitValue = false;
        }
        field(50023;"Мероприятие Но.";Code[20])
        {
        }
        field(50024;"Меню Но.";Code[10])
        {
            TableRelation = "Учт. Меню Заголовок";

            trigger OnValidate()
            var
                _recMenu: Record "Учт. Меню Заголовок";
            begin
                if _recMenu.Get("Меню Но.") then begin
                  if _recMenu."Menu Type" = _recMenu."Menu Type" :: Buffet then
                    "Признак Заказа" := "Признак Заказа" ::"Шведский Стол"
                  else
                    "Признак Заказа" := "Признак Заказа" ::"По Меню";
                end
                else
                  "Признак Заказа" := "Признак Заказа" ::"По Меню";
            end;
        }
        field(50025;"Питание Зал Строка Но.";Integer)
        {
        }
        field(50026;"Питание Строка Но.";Integer)
        {
        }
        field(50029;"Сумма Скидки";Decimal)
        {
            InitValue = 0;
        }
        field(50100;"Временно";Boolean)
        {
        }
        field(50180;"Признак Заказа";Option)
        {
            Description = 'yuri 280815';
            OptionMembers = "По Меню","Бизнес Ланч","Шведский Стол";

            trigger OnValidate()
            var
                _recLine: Record "_Заказ Ресторана Строка";
                _recLineNew: Record "_Заказ Ресторана Строка";
                _recMenuLineLunch: Record "Menu Line Lunch";
                _Qty: Decimal;
                _recItem: Record Item;
            begin
                if ("Признак Заказа" = "Признак Заказа" :: "Бизнес Ланч") and ("Строка Но." = "Main Line For Lunch") then begin
                  _recMenuLineLunch.SetRange("Документ Но.", "Меню Но.");
                  _recMenuLineLunch.SetRange("Строка Но.", "Номер Позиции В Меню");
                  _recMenuLineLunch.SetRange("Товар Но.", "Код Блюда");
                  _recMenuLineLunch.SetRange("Тип позиции", "Тип позиции");
                  _recMenuLineLunch.SetFilter("Qty Item", '>%1',0);
                  if _recMenuLineLunch.FindSet then
                  repeat
                    _recLine.SetRange("Заказ Но.", "Заказ Но.");
                    _recLine.SetRange("Статус Блюда", _recLine."Статус Блюда" :: "Выбрано");
                    _recLine.SetRange("Меню Но.","Меню Но.");
                    _recLine.SetFilter("Признак Заказа", '<>%1',_recLine."Признак Заказа"::"Бизнес Ланч");
                    if _recMenuLineLunch."Max Amount" > 0 then
                      _recLine.SetFilter("Цена Единицы", '<=%1', _recMenuLineLunch."Max Amount");
                    if _recLine.FindSet(true) then
                    repeat
                      //_recMenuLine.SETRANGE("Документ Но.", _recLine."Меню Но.");
                      //_recMenuLine.SETRANGE("Товар Но.", _recLine."Код Блюда");
                      //_recMenuLine.SETRANGE("Строка Но.", _recLine."Номер Позиции В Меню");
                      //_recMenuLine.SETRANGE("Тип позиции", _recLine."Тип позиции");
                      //_recMenuLine.SETFILTER("Товар Группа Классификации", _recMenuLineLunch."Class.Filter");
                      //IF _recMenuLine.FINDFIRST THEN BEGIN
                      _recItem.SetRange("No.", _recLine."Код Блюда");
                      _recItem.SetFilter("Экран Группа Классификации",_recMenuLineLunch."Class.Filter");
                      if _recItem.FindFirst then begin
                        if _recLine.Количество <= _recMenuLineLunch."Qty Item" then begin
                          _recLine.Validate("Цена Единицы", 0);
                          _recLine.Validate("Main Line For Lunch", "Строка Но.");
                          _recLine.Validate("Признак Заказа", _recLine."Признак Заказа" ::"Бизнес Ланч");
                          _recLine.Modify;
                        end
                        else begin
                          _recLineNew.Init;
                          _recLineNew.TransferFields(_recLine);
                          _recLineNew.Validate("Строка Но.", _recLine."Строка Но." + 1000);
                          _recLineNew.Validate(Количество,_recLine.Количество - _recMenuLineLunch."Qty Item");
                          _recLineNew.Insert(true);

                          _recLine.Validate(Количество, _recMenuLineLunch."Qty Item");
                          _recLine.Validate("Цена Единицы", 0);
                          _recLine.Validate("Main Line For Lunch", "Строка Но.");
                          _recLine.Validate("Признак Заказа", _recLine."Признак Заказа" ::"Бизнес Ланч");
                          _recLine.Modify;
                        end;

                        _recMenuLineLunch."Qty Item" -= _recLine.Количество;
                      end;
                    until (_recLine.Next = 0) or (_recMenuLineLunch."Qty Item" <= 0);
                  until _recMenuLineLunch.Next = 0;
                end;
            end;
        }
        field(50200;"Очередь";Integer)
        {
        }
        field(50201;"Комментарий";Text[250])
        {
        }
        field(50202;"Блюдо Подано";Boolean)
        {
        }
        field(50300;"Гость Но.";Integer)
        {
        }
        field(50302;"Source Type";Option)
        {
            Caption = 'Тип Источника';
            Description = 'yuri 191114';
            OptionCaption = 'терминал,планшет,электронное меню';
            OptionMembers = terminal,tablet,emenu;
        }
        field(50303;"Source Code";Text[30])
        {
            Caption = 'Код Источника';
            Description = 'yuri 191114';
            TableRelation = IF ("Source Type"=CONST(terminal)) "_Касса Ресторана Настройка"."Код"
                            ELSE IF ("Source Type"=FILTER(tablet|emenu)) Devices.ID;
        }
        field(50304;"Trans. Round";Integer)
        {
            Caption = 'Раунд Транзакций';
            Description = 'yuri 191114';
        }
        field(50305;"Table No.";Integer)
        {
            Caption = 'Столик Но.';
            Description = 'yuri 241114';
            TableRelation = "Ресторан Столики"."Столик Но.";
        }
        field(50500;"Блюдо Приготовлено";Boolean)
        {
        }
        field(50501;"Hall Y-Shift";Integer)
        {
            Caption = 'Y-Смена Для Зала';
            TableRelation = "Y-Shifts";
        }
        field(50502;"Блюдо Из Группы";Code[10])
        {
            TableRelation = "_Группа Блюд Заголовок";
        }
        field(50503;"Класс Блюда";Integer)
        {
        }
        field(50504;"Location Y-Shift";Integer)
        {
            Caption = 'Y-Смена Для Склада';
            TableRelation = "Y-Shifts";
        }
        field(50510;"Раунд Номер";Integer)
        {
        }
        field(50517;"Код Склада Списания";Code[10])
        {
            TableRelation = Location;

            trigger OnValidate()
            var
                _recLC: Record Location;
            begin
                UpdateLocation();

                "Owner Company" := GetOwnerCompanyId("Sales Company","Код Склада Списания");
            end;
        }
        field(50520;"Код Ячейки";Code[10])
        {
            TableRelation = Bin.Code WHERE ("Location Code"=FIELD("Код Склада Списания"));

            trigger OnValidate()
            begin
                UpdateLocation();
            end;
        }
        field(50521;"Перенесена Из Заказа Но.";Code[20])
        {
        }
        field(50522;"Перенесена В Заказа Но.";Code[20])
        {
        }
        field(50523;"Номер Позиции В Меню";Integer)
        {
        }
        field(50550;"Тип позиции";Option)
        {
            OptionMembers = "Товар","Ресурс";
        }
        field(50551;"Блок Услуги системы";Boolean)
        {
        }
        field(50552;"Код системы";Integer)
        {
            TableRelation = "Restaurant External System";
        }
        field(50555;"Цифровая Подпись Клиента";Code[10])
        {
        }
        field(50556;"Код Услуги";Code[10])
        {
            TableRelation = "Service Type";
        }
        field(50557;DiscountCard;Text[30])
        {
        }
        field(51002;"Позиция Выдана";Boolean)
        {
        }
        field(52003;"Перенос стола";Integer)
        {
            Description = 'Бильярд смена стола';
        }
        field(52004;"Чек Боулинга";Integer)
        {
            Description = 'Связь услуги с боулингом';
        }
        field(52005;"Код Системы Боулинга";Integer)
        {
        }
        field(52006;ClubBonusPrice;Decimal)
        {
        }
        field(52007;ClubBonusPriceSumm;Decimal)
        {
        }
        field(52008;ClubBonusAmount;Decimal)
        {
        }
        field(52009;"СреднСебест";Decimal)
        {
        }
        field(52010;"Tariff Extra System";Code[10])
        {
            Caption = 'Тариф Внешней Системы';
            Description = 'yuri 120814 (76892)';
            TableRelation = "Wi-Fi Tariff".Code WHERE ("Source Type"=CONST(RST));
        }
        field(52011;"Wi-Fi Job Upload";Integer)
        {
            Caption = 'Wi-Fi Промокод';
            Description = 'yuri 120814 (76892)';
        }
        field(52012;"Main Line For Lunch";Integer)
        {
            Caption = 'Строка Ланча';
            Description = 'yuri 040216 (128051)';
        }
        field(52111;"Название Стола";Text[30])
        {
            CalcFormula = Lookup("_Заказ Ресторана Заголовок"."НазваниеСтола" WHERE ("Заказ Но."=FIELD("Заказ Но.")));
            FieldClass = FlowField;
        }
        field(53003;"Питание Подробно Строка Но.";Integer)
        {
            Description = 'VAN 130115';
        }
        field(54001;dim8;Code[20])
        {
            Caption = 'Консал. Ед.';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('КОНСОЛИДАЦИОННАЯ ЕД.'));

            trigger OnLookup()
            var
                _CUAdd: Codeunit "_Ресторан Доп. Функции";
            begin
                _CUAdd.LookUpDim8(dim8);
            end;
        }
        field(54002;"Код Кассы";Code[10])
        {
            Description = 'yuri 100114';
        }
        field(54003;"Need MOL Order";Boolean)
        {
            Caption = 'Необходима Заявка';
            Description = 'yuri 150517';

            trigger OnValidate()
            var
                _RestManagerSetup: Record "Менеджер Ресторана Настройка";
                _Date: Date;
                _recRestMOLLink: Record "Rest. MOL Order Link";
            begin
                if "Need MOL Order" then begin
                  _RestManagerSetup.Get();
                  if "Время Заказа" < _RestManagerSetup."Время сдвига отчетности" then
                    _Date := "Дата Заказа" - 1
                  else
                    _Date := "Дата Заказа";

                  if "Тип позиции" = "Тип позиции" :: "Товар" then
                    if ("Статус Блюда" = "Статус Блюда"::"Заказано") or
                       ("Статус Блюда" = "Статус Блюда"::"Отменено") and not "Блюдо Приготовлено" then begin
                      _recRestMOLLink.Init;
                      _recRestMOLLink.ID := 0;
                      _recRestMOLLink."Rest.Order No." :=  "Заказ Но.";
                      _recRestMOLLink."Rest.Order Line" := "Строка Но.";
                      _recRestMOLLink."Item No." :=  "Код Блюда";
                      _recRestMOLLink."Location Code" := "Код Склада Списания";
                      _recRestMOLLink."Bin Code" :=  "Код Ячейки";
                      _recRestMOLLink."Posting Date" :=  _Date;
                      _recRestMOLLink."Unit of Measure" :=  "Код Единицы Измерения";
                      _recRestMOLLink.Qty :=  Количество;
                      _recRestMOLLink."Sale Hall Code" :=  "Код Зала Продажи";
                      _recRestMOLLink.Insert(true);

                      "MOL Order No." := Format(_recRestMOLLink.ID);
                    end;

                  if "MOL Order No." = '' then
                    "MOL Order No." := 'AAA';
                end;
            end;
        }
        field(54004;"MOL Order No.";Code[20])
        {
            Caption = 'Номер Заявки';
            Description = 'yuri 150517';
            TableRelation = "Order MOL Header";
        }
        field(69000;"Bonus Discount Amount";Decimal)
        {
            Caption = 'Bonus Discount Amount';
            Description = '#36211';
        }
        field(69001;"Amount (ACY)";Decimal)
        {
            Caption = 'Amount (ACY)';
            Description = '76691';
        }
        field(69002;"Disc. Amount (ACY)";Decimal)
        {
            Caption = 'Disc. Amount (ACY)';
            Description = '76691';
        }
        field(69003;"Bonus Disc. Amount (ACY)";Decimal)
        {
            Caption = 'Bonus Disc. Amount (ACY)';
            Description = '76691';
        }
        field(69004;"Менеджер Группа Классификации";Code[20])
        {
            Description = '76691';
            TableRelation = "Классификация Группа"."Код" WHERE ("Тип"=CONST("Учетный"),
                                                                "Принадлежит Упр"=CONST(true));
        }
        field(69006;"Discount Code";Code[10])
        {
            Caption = 'Код скидки';
            TableRelation = "Discount Code";
        }
        field(69007;"Discount Rule No.";Integer)
        {
            Caption = 'Rule No.';
            TableRelation = "Discount Rule";
        }
        field(69008;"Discount %";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Discount %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                //apik 200716 (164531) > скидки
                UpdateAmounts;
                //apik 200716 (164531) < скидки
            end;
        }
        field(69018;"Sales Company";Integer)
        {
            Caption = 'Sales Company';
        }
        field(69019;"Owner Company";Integer)
        {
            Caption = 'Sales Company';
        }
        field(69020;"Storno Line No.";Integer)
        {
            Caption = 'Сторно строки Но.';
            InitValue = 0;
        }
        field(21001400;dim1;Code[20])
        {
            Caption = 'Центр Учета';
            TableRelation = "Dimension Value".Code WHERE ("Dim 1"=CONST(true));
        }
        field(21001401;dim2;Code[20])
        {
            Caption = 'Статья Бюджета';
            TableRelation = "Dimension Value".Code WHERE ("Dim 2"=CONST(true));
        }
        field(21001402;dim3;Code[20])
        {
            Caption = 'Код Объекта';
            TableRelation = "Dimension Value".Code WHERE ("Dim 3"=CONST(true));
        }
        field(21001403;dim4;Code[20])
        {
            Caption = 'ЕКТУ';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('ЕКТУ'));
        }
        field(21001404;dim5;Code[20])
        {
            Caption = 'Группа Сплит Меню';
        }
        field(21001405;dim6;Code[20])
        {
            Caption = 'Официант';
            TableRelation = "_Сотрудник Ресторана"."Но." WHERE ("Но."=FIELD(dim6));
        }
        field(21001406;"Storno Order No.";Code[20])
        {
            Caption = 'Заказ Для Сторно';
        }
        field(21001509;"Hotel Guest No.";Code[20])
        {
            Caption = 'Гость Отеля Но.';
            TableRelation = Guests;
        }
        field(21001512;"Dim1 for Cost";Code[20])
        {
            Caption = 'ЦУ для издержек';
            Description = 'yuri 281117';
            TableRelation = "Dimension Value".Code WHERE ("Dim 1"=CONST(true));
        }
        field(21001513;"Dim2 for Cost";Code[20])
        {
            Caption = 'СБ для издержек';
            Description = 'yuri 281117';
            TableRelation = "Dimension Value".Code WHERE ("Dim 2"=CONST(true));
        }
    }

    keys
    {
        key(Key1;"Заказ Но.","Строка Но.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Сумма","Сумма Скидки";
        }
        key(Key2;"Заказ Но.","Внешний Заказ Но.","Статус Блюда")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Сумма";
        }
        key(Key3;"Заказ Но.","Код Блюда","Статус Блюда","Цена Единицы","Код Услуги")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество","Сумма Скидки",ClubBonusAmount;
        }
        key(Key4;"Заказ Но.","Код Блюда","Статус Блюда","Цена Единицы","Раунд Номер")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество","Сумма Скидки";
        }
        key(Key5;"Заказ Но.","Блюдо Из Группы","Класс Блюда","Статус Блюда")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество","Сумма";
        }
        key(Key6;"Заказ Но.","Код Блюда","Блюдо Из Группы","Класс Блюда","Статус Блюда","Need MOL Order","MOL Order No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество";
        }
        key(Key7;"Заказ Но.","Блюдо Из Группы","Статус Блюда")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Сумма";
        }
        key(Key8;"Очередь")
        {
        }
        key(Key9;"Раунд Номер")
        {
        }
        key(Key10;"Заказ Но.","Код Блюда","Статус Блюда","Цена Единицы","Раунд Номер","Меню Но.","Номер Позиции В Меню")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество","Сумма Скидки";
        }
        key(Key11;"Заказ Но.","Код Блюда","Статус Блюда","Цена Единицы","Меню Но.","Номер Позиции В Меню")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Количество","Сумма";
        }
        key(Key12;"Заказ Но.","Гость Но.","Очередь","Строка Но.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        _recLine: Record "_Заказ Ресторана Строка";
    begin
        if ("Признак Заказа" = "Признак Заказа"::"Бизнес Ланч") and ("Строка Но." = "Main Line For Lunch") then begin
          _recLine.SetRange("Заказ Но.", "Заказ Но.");
          _recLine.SetRange("Признак Заказа",_recLine."Признак Заказа"::"Бизнес Ланч");
          _recLine.SetRange("Main Line For Lunch", "Строка Но.");
          _recLine.SetFilter("Строка Но.", '<>%1',"Строка Но.");
          _recLine.SetRange("Статус Блюда", _recLine."Статус Блюда" :: "Выбрано");
          _recLine.DeleteAll;
        end;
    end;

    trigger OnInsert()
    var
        _recLine: Record "_Заказ Ресторана Строка";
        _recMenuLine: Record "Учт. Меню Строка";
        Item: Record Item;
    begin
        if "Строка Но." = 0 then begin
          _recLine.SetRange("Заказ Но.", "Заказ Но.");
          if _recLine.FindLast then
            "Строка Но." := _recLine."Строка Но." + 10
          else
            "Строка Но." := 10;
        end;

        //yuri 040216 >
        //выделяем бизнес ланчи
        if _recMenuLine.Get("Меню Но.","Код Блюда","Номер Позиции В Меню","Тип позиции") then begin
          _recMenuLine.CalcFields("Lunch Item");
          if _recMenuLine."Lunch Item" then begin
            Validate("Main Line For Lunch", "Строка Но.");
            Validate("Признак Заказа", "Признак Заказа" :: "Бизнес Ланч");
          end;
        end;
        //yuri 040216 <
    end;

    var
        "Сотрудник": Record Employee;
        "УчтМенюЗаголовок": Record "Учт. Меню Заголовок";
        "УчтМенюСтрока": Record "Учт. Меню Строка";
        "ЗаказРесторанаЗаголовок": Record "_Заказ Ресторана Заголовок";
        "Блюда": Record Item;
        "РесторанЗалы": Record "KR Hall";
        "ЗаказРесторанаСтрока": Record "_Заказ Ресторана Строка";
        CUAdd: Codeunit "_Ресторан Доп. Функции";
        DimMgt: Codeunit DimensionManagement;
        DiscountMgt: Codeunit "Discount Mgt.";
        DiscountCode: Record "Discount Code";
        RoundMethod: Record "Rounding Method";
        DiscAmount: Decimal;
        RoundIt: Boolean;
        ClubGSetup: Record ClubGSetup;
        CurrencyLoc: Record Currency;
        CurrencyKOR: Record Currency;
        GSetupRead: Boolean;
        CurrExchRate: Record "Currency Exchange Rate";
        HS: Record "Hotel Setup";
        "КассаНастройка": Record "_Касса Ресторана Настройка";
        LocMgt: Codeunit "Localisation Management";

    procedure SetDimentions()
    var
        MenuHeader: Record "Учт. Меню Заголовок";
        MenuLine: Record "Учт. Меню Строка";
        GSetup: Record "Менеджер Ресторана Настройка";
        halls: Record "KR Hall";
        header: Record "_Заказ Ресторана Заголовок";
        _DefDim: Record "Default Dimension";
        _tProjectScheduler: Record "Project Schedule";
        _RR: Record "Rooms Reservation";
        _TEventHeader: Record "Мероприятие Заголовок";
        _TEventType: Record "Мероприятие Вид";
        Dim4Fixed: Boolean;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        _recDigSig: Record "Ресторан Цифровая Подпись";
    begin
        if not GSetup.Get() then
          GSetup.Init;
        header.Get("Заказ Но.");

        if dim4 <> '' then
          Dim4Fixed := true;

        //========================================================
        //КЕ
        dim8:=GSetup.Dim8;

        if halls.Get("Код Зала Продажи") then begin
           dim1:=halls.Dim1;
           if halls."Fixed Dim4" then begin
             Dim4Fixed := halls."Fixed Dim4";
             dim4 := halls.Dim4;
           end;

           if _DefDim.Get(DATABASE::"KR Hall","Код Зала Продажи",GSetup."Shortcut Dimension 8 Code") then
              dim8:=_DefDim."Dimension Value Code";
        end;

        //========================================================
        //ЦУ
        if MenuHeader.Get("Меню Но.") then
          if MenuHeader.Dim1 <> '' then begin
            dim1:=MenuHeader.Dim1;
            if MenuHeader."Fixed Dim4" then begin
              Dim4Fixed := MenuHeader."Fixed Dim4";
              dim4 := MenuHeader.Dim4;
            end;
          end;


        //========================================================
        //СТАТЬЯ БЮДЖЕТА
        if MenuLine.Get("Меню Но.","Код Блюда","Номер Позиции В Меню","Тип позиции") then begin
          dim2:=MenuLine.Dim2;
          dim5:=Format(MenuLine.DimGroup);
        end;

        //========================================================
        //КОД ОБЪЕКТА
        dim3 := _tProjectScheduler.GetDim3("Код Зала Продажи",CreateDateTime("Дата Заказа","Время Заказа"));

        if header.dim3 <> '' then
          dim3 := header.dim3;

        //========================================================
        //ЕКТУ
        if not Dim4Fixed then begin
          dim4 := GSetup.Dim4;
          if MenuHeader.Get("Меню Но.") then
            if MenuHeader.Dim4 <> '' then
              dim4 := MenuHeader.Dim4
            else if MenuHeader."Menu Type" = MenuHeader."Menu Type"::Service then
              dim4 := GSetup.Dim4Compl;
        end;
        if MenuHeader.Dim3 <> '' then
          dim3 := MenuHeader.Dim3;
        if MenuLine.Dim3 <> '' then
          dim3 := MenuLine.Dim3;
        if (header."Бронирование Но." <> '') then begin
          if _TEventHeader.Get(header."Бронирование Но.") then begin
            dim3 := _TEventHeader.dim3;

            if not Dim4Fixed then begin
              if _TEventHeader.dim4 <> '' then
                dim4 := _TEventHeader.dim4
              else if _TEventType.Get(_TEventHeader."Вид Мероприятия") then
                dim4 := _TEventType."Dimension 4 Value";
            end
          end else
            if _RR.Get(header."Бронирование Но.") then
              if _RR.dim3 <> '' then
                dim3 := _RR.dim3;

          if not Dim4Fixed then
            //yuri 291117
            //IF (STRPOS(GSetup."Фильтр по Пеймастерам в отч.", header."Бронирование Но.") <> 0) OR
            //   (STRPOS(CUAdd.NOTServicePM("Код Зала Продажи"), header."Бронирование Но.") <> 0) THEN
            if header."Цифровая Подпись Клиента" <> '' then
            dim4 := GSetup.Dim4Compl;
        end;

        //yuri 301117
        if _recDigSig.Get(header."Цифровая Подпись Клиента") then begin
          "Dim1 for Cost" := _recDigSig."Dim1 for Cost";
          "Dim2 for Cost" := _recDigSig."Dim2 for Cost";
        end;

        if dim4 = GSetup.Dim4Compl then
          dim3 := '';

        GetDocDimensions(TempDimSetEntry);
        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    procedure GetDocDimensions(var TempDimEntry: Record "Dimension Set Entry")
    var
        GSetup: Record "Менеджер Ресторана Настройка";
        GLSetup: Record "General Ledger Setup";
    begin
        //apik 280415 (104159) получить совместимые измерения
        GLSetup.Get;
        GSetup.Get;
        if dim1 <> '' then begin
          TempDimEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
          TempDimEntry."Dimension Value Code" := dim1;
          if TempDimEntry."Dimension Code" <> '' then
            if TempDimEntry.Insert then;
        end;
        if dim3 <> '' then begin
          TempDimEntry."Dimension Code" := GLSetup."Global Dimension 2 Code";
          TempDimEntry."Dimension Value Code" := dim2;
          if TempDimEntry."Dimension Code" <> '' then
            if TempDimEntry.Insert then;
        end;
        if dim3 <> '' then begin
          TempDimEntry."Dimension Code" := GSetup."Shortcut Dimension 3 Code";
          TempDimEntry."Dimension Value Code" := dim3;
          if TempDimEntry."Dimension Code" <> '' then
            if TempDimEntry.Insert then;
        end;
        if dim4 <> '' then begin
          TempDimEntry."Dimension Code" := GSetup."Shortcut Dimension 4 Code";
          TempDimEntry."Dimension Value Code" := dim4;
          if TempDimEntry."Dimension Code" <> '' then
            if TempDimEntry.Insert then;
        end;
        if dim8 <> '' then begin
          TempDimEntry."Dimension Code" := GSetup."Shortcut Dimension 8 Code";
          TempDimEntry."Dimension Value Code" := dim8;
          if TempDimEntry."Dimension Code" <> '' then
            if TempDimEntry.Insert then;
        end;
    end;

    procedure GetOwnerCompanyId(CompanyId: Integer;LocationCode: Code[20]) OwnerId: Integer
    var
        recLocation: Record Location;
        recICPartner: Record "IC Partner";
        recCompany: Record Company;
    begin
        //apik 170715 получение номера фирмы хозяина товара
        OwnerId := CompanyId; //default
        if recCompany.FindById(CompanyId) then begin
          recLocation.ChangeCompany(recCompany.Name);
          recICPartner.ChangeCompany(recCompany.Name);
          if recLocation.Get(LocationCode) and
            recICPartner.Get(recLocation."IC Partner Owner") and
            (recICPartner."Inbox Type" = recICPartner."Inbox Type"::Database) and
            recCompany.Get(recICPartner."Inbox Details") then
             OwnerId := recCompany."No.";
        end;
    end;

    procedure UpdateLocation()
    var
        _recHallLocRepl: Record "Menu Hall Location Replace";
    begin
        if _recHallLocRepl.Get("Меню Но.", "Код Зала Продажи", "Код Склада Списания", "Код Ячейки") then begin
          "Код Склада Списания" := _recHallLocRepl."New Location Code";
          "Код Ячейки" := _recHallLocRepl."New Bin Code";
        end;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2 %3',TableCaption,"Заказ Но.","Строка Но."));
    end;

    procedure UpdateAmounts()
    begin
        //apik 200716 (164531) скидки
        Сумма := Round(Количество * "Цена Единицы",0.01);
        ClubBonusPriceSumm := Round(Количество * ClubBonusPrice,0.01);
        if "Discount Code" <> '' then
          if DiscountCode.Get("Discount Code") then
          if not DiscountCode."Price Change" then begin
            RoundIt := RoundMethod.Get(DiscountCode."Rounding Method");
            DiscAmount := Сумма * "Discount %" / 100;
            if RoundIt then
              DiscAmount := RoundMethod.RoundAmount(DiscAmount);
            "Сумма Скидки" := DiscAmount;
          end;
    end;

    procedure GetGSetup()
    var
        CompName: Text;
    begin
        //apik 271213 (36211) читаем настройки бонусов
        if not GSetupRead then begin
          CompName := LocMgt.GetClientName;
          КассаНастройка.Reset;
          КассаНастройка.SetRange("Терминал Но.", CompName);
          КассаНастройка.SetRange("Код Зала","Код Зала Продажи");
          if not КассаНастройка.FindFirst then
            Clear(КассаНастройка);

          if КассаНастройка."Касса Клон" <> '' then begin
             КассаНастройка.Reset;
             КассаНастройка.SetRange(Код,КассаНастройка."Касса Клон");
             КассаНастройка.SetRange("Терминал Но.", CompName);
             if not КассаНастройка.FindFirst then
               Clear(КассаНастройка);
          end;
          HS.GetLocal;
          if КассаНастройка.Код = '' then
            КассаНастройка.ClubRegin := HS."Club Region Code";
          Clear(ClubGSetup);

          if КассаНастройка.ClubRegin <> '' then
            ClubGSetup.Get(КассаНастройка.ClubRegin)
          else
            ClubGSetup.FindFirst;

        //  BonusActive := ClubGSetup."Bonus Service Type" <> '';
          CurrencyLoc.InitRoundingPrecision;
          CurrencyKOR.InitRoundingPrecision;
          if CurrencyKOR.Get(ClubGSetup."Bonus Currency Code") then;
          GSetupRead := true;
        end;
    end;

    procedure ConvBonusLCY(AmtKCY: Decimal;aDate: Date) AmtLCY: Decimal
    begin
        //apik 051113 (53158)
        //assert: сетап клуба прочитан
        AmtLCY := Round(CurrExchRate.ExchangeAmtFCYToLCY(aDate,ClubGSetup."Bonus Currency Code",AmtKCY,
           CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
           CurrencyLoc."Amount Rounding Precision");
    end;

    procedure ConvBonusKCY(AmtLCY: Decimal;aDate: Date) AmtKCY: Decimal
    begin
        //apik 051113 (53158)
        //assert: сетап клуба прочитан
        AmtKCY := Round(CurrExchRate.ExchangeAmtLCYToFCY(aDate,ClubGSetup."Bonus Currency Code",AmtLCY,
           CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
           CurrencyKOR."Amount Rounding Precision");
    end;
}

