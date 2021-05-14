table 21001400 "Менеджер Ресторана Настройка"
{
    // version KRF,res,CK CHECK010420

    // yuri > 28.05.13 + Dim8 Консал. Ед.
    // csa 290914 (67622) - логирование действия пользователя
    // apik 291014 (79348) добавлено поле Storno Resource No.

    DataPerCompany = false;

    fields
    {
        field(1;"Ключ";Code[10])
        {
            TableRelation = "KR Hall";
        }
        field(2;"Сотрудник Ресторана Серия Но.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3;"ПО Магия";Boolean)
        {
        }
        field(4;"ПО RKeeper";Boolean)
        {
        }
        field(5;"Тип Передачи Данных";Option)
        {
            OptionMembers = "Через Промежуточные Таблицы NF","Напрямую в Таблицы ПО";
        }
        field(6;"Комлекс. Питание Серия Номеров";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7;"Тип Регистрации Персонала";Option)
        {
            OptionMembers = "Код","Ключ","Карта";
        }
        field(8;"Предв. Заказ Рест. Серия Но.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9;"Код Измерения для Класс. Блюд";Code[20])
        {
            TableRelation = Item;
        }
        field(10;"Удалять Заказ при Полном Перем";Boolean)
        {
        }
        field(11;"Создав. Новый Заказ при Перещ.";Boolean)
        {
        }
        field(13;"Фин. Журнал Код Шаблона";Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(14;"Фин. Журнал Код Раздел";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Фин. Журнал Код Шаблона"));
        }
        field(15;"Проводить По Бухгалтерии";Option)
        {
            OptionMembers = "Суммарно","По Отделам и Проектам";
        }
        field(18;"Оплаты Ресторана Серия Номеров";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(19;"Касса Ресторана";Code[10])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(20;"Тип Регистрации Гостя";Option)
        {
            OptionMembers = "Код","Карта";
        }
        field(21;"Тип Расчета в Баре";Option)
        {
            OptionMembers = "Без Вариантов","С Вариантами";
        }
        field(22;"Тип Передачи в Счет Гостя";Option)
        {
            OptionMembers = "По Номеру Комнаты","По Номеру Бронирования";
        }
        field(24;"Счет Но.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(25;"Учт. Счет Но.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(26;"Тип Суммирования";Option)
        {
            OptionMembers = " ","По Блюдам";
        }
        field(27;"База Источник";Boolean)
        {
        }
        field(28;"Менеджер Ресторана";Text[5])
        {
        }
        field(29;"Формиров. Гость Услуга Строка";Boolean)
        {
        }
        field(51;"Фин. Журнал Код Шаблона Агент";Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(52;"Фин. Журнал Код Раздел Агент";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Фин. Журнал Код Шаблона Агент"));
        }
        field(53;"Агент Поставщик Но.";Code[20])
        {
            TableRelation = Vendor;
        }
        field(54;"Агент Учетная Группа";Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
        }
        field(50000;"Кред. Карта Клише";Code[20])
        {
            Caption = 'Кред. Карты КЛИШЕ';
        }
        field(50001;"Кред. Карта Клише (Амер. Эксп)";Code[20])
        {
            Caption = 'Кред. Карты КЛИШЕ (Am.Exp.)';
        }
        field(50002;"Карточка Позиция Начало";Integer)
        {
        }
        field(50003;"Карточка Позиция Окончание";Integer)
        {
        }
        field(50004;"Диск. Карт. Позиция Начало";Integer)
        {
        }
        field(50005;"Диск. Карт. Позиция Окончание";Integer)
        {
        }
        field(50006;"Менеджер Ресторана Код";Code[5])
        {
            TableRelation = "_Сотрудник Ресторана";

            trigger OnValidate()
            begin

                СотрудникРесторана.Reset;
                СотрудникРесторана.SetRange(СотрудникРесторана."Но.","Менеджер Ресторана Код");
                if СотрудникРесторана.Find('-') then
                  "Менеджер Ресторана" := СотрудникРесторана.Фамилия + ' ' + СотрудникРесторана.Инициалы;
            end;
        }
        field(50007;"Тип Опред. Проек. Продажи Блюд";Option)
        {
            OptionMembers = "По Проекту Зала","По Проекту Блюд";
        }
        field(50018;"Билеты Оплаты Серия Номеров";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50019;"Касса Консьержа";Code[10])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50024;"Счет Но. Безнал.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50025;"Учт. Счет Но. Безнал.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50026;"Блюда Только Из Меню";Boolean)
        {
        }
        field(50027;"Классификатор Только Из Меню";Boolean)
        {
        }
        field(50029;"Откр. Заказы Закрытие Смены";Boolean)
        {
        }
        field(50030;"Откр. Смены Закрытие Z-смены";Boolean)
        {
        }
        field(50031;"Откр. Z-смены Закрытие Зала";Boolean)
        {
        }
        field(50032;"Откр. Залы Закрытие Предприяти";Boolean)
        {
        }
        field(50033;"Название Холдинга";Text[60])
        {
        }
        field(50034;"Координаты Рабочей обл X";Integer)
        {
        }
        field(50035;"Координаты Рабочей обл Y";Integer)
        {
        }
        field(50036;"Размер рабочей обл X";Integer)
        {
        }
        field(50037;"Размер рабочей обл Y";Integer)
        {
        }
        field(50038;"Def PayMaster Казино";Code[10])
        {
        }
        field(50039;"Def PayMaster G";Code[10])
        {
        }
        field(50040;"Границы кода авторизации";Text[10])
        {
        }
        field(50041;"Фильтр по Пеймастерам Сервис Б";Text[250])
        {
        }
        field(50042;"Время сдвига отчетности";Time)
        {
            Caption = 'Время Снятия Z';
        }
        field(50043;"Фильтр по Пеймастерам в отч.";Text[250])
        {
        }
        field(50044;"Shortcut Dimension 3 Code";Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(50045;"Shortcut Dimension 8 Code";Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(50046;Dim8;Code[20])
        {
            Caption = 'Консал. Ед.';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 8 Code"));
        }
        field(50047;"Shortcut Dimension 4 Code";Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = Dimension;
        }
        field(50048;Dim4;Code[20])
        {
            Caption = 'ЕКТУ';
            Description = 'yuri 210613';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(50049;Dim4Compl;Code[20])
        {
            Caption = 'ЕКТУ COMPL';
            Description = 'yuri 210613';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(50050;Dim4EPR;Code[20])
        {
            Caption = 'ЕКТУ EPR';
            Description = 'yuri 130314';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(50051;Dim4Breakfast;Code[20])
        {
            Caption = 'ЕКТУ Завтрак';
            Description = 'yuri 010714';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(50052;"Man.Class.Openfood";Code[100])
        {
            Caption = 'Классификатор Открытая Цена';
            TableRelation = "Классификация Группа"."Код" WHERE ("Принадлежит Упр"=CONST(true));
            ValidateTableRelation = false;
        }
        field(50053;"Path for Picture";Text[250])
        {
            Caption = 'Путь для Картинок';
            Description = 'yuri 211114';
        }
        field(50054;"Height for Picture";Integer)
        {
            Caption = 'Высота Картинки';
            Description = 'yuri 211114';
        }
        field(50055;"Width for Picture";Integer)
        {
            Caption = 'Ширина Картинки';
            Description = 'yuri 211114';
        }
        field(50056;"Temp Picture";BLOB)
        {
            Caption = 'Картинка';
            Description = 'yuri 211114';
        }
        field(50057;"Night Time From";Time)
        {
            Caption = 'Время Ночь С';
            Description = 'yuri 101214';
        }
        field(50058;"Night Time To";Time)
        {
            Caption = 'Время Ночь По';
            Description = 'yuri 101214';
        }
        field(50059;"Salary Unit of Meas.";Code[10])
        {
            Caption = 'Зарплата Ед. Измерения';
            Description = 'yuri 171214';
            TableRelation = "Unit of Measure";
        }
        field(50060;"Minutes For Hour";Integer)
        {
            Caption = 'Минут для округления до часа';
        }
        field(50061;"Element Code";Code[20])
        {
            Caption = 'Element Code';
            Description = 'yuri 211214';
            TableRelation = "Payroll Element";
            ValidateTableRelation = false;
        }
        field(50062;"Menu Happy Hours";Code[20])
        {
            Caption = 'Фильтр Меню Happy Hours';
            Description = 'yuri 100415';
            TableRelation = "Учт. Меню Заголовок";
            ValidateTableRelation = false;
        }
        field(50063;"Mng. Class. Food";Code[100])
        {
            Caption = 'Менеджер Класс. Еда';
            Description = 'yuri 100415';
            TableRelation = "Классификация Группа"."Код" WHERE ("Принадлежит Упр"=CONST(true));
            ValidateTableRelation = false;
        }
        field(50064;"Mng. Class. Bev";Code[100])
        {
            Caption = 'Менеджер Класс. Без Алк.';
            Description = 'yuri 100415';
            TableRelation = "Классификация Группа"."Код" WHERE ("Принадлежит Упр"=CONST(true));
            ValidateTableRelation = false;
        }
        field(50065;"Mng. Class. Alko Bev";Code[100])
        {
            Caption = 'Менеджер Класс. Алк.';
            Description = 'yuri 100415';
            TableRelation = "Классификация Группа"."Код" WHERE ("Принадлежит Упр"=CONST(true));
            ValidateTableRelation = false;
        }
        field(50066;Dim4CB;Code[20])
        {
            Caption = 'ЕКТУ C&&B';
            Description = 'yuri 270515';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(50067;Dim4FBHB;Code[20])
        {
            Caption = 'ЕКТУ FB-HB';
            Description = 'yuri 130317';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Shortcut Dimension 4 Code"));
        }
        field(67000;"Active Personal Log";Boolean)
        {
            Caption = 'Включить лог действий пользователя';
            Description = '#67622';
        }
        field(69000;"Storno Resource No.";Code[20])
        {
            Caption = 'Storno Resource No.';
            Description = '79348';
            TableRelation = Resource;
        }
        field(69001;"Storno Restore Role";Code[20])
        {
            Caption = 'Storno Restore Role';
            Description = '79348';
            TableRelation = "Permission Set"."Role ID";
        }
        field(69002;"Set Off Series No.";Code[10])
        {
            Caption = 'Set Off Series No.';
            TableRelation = "No. Series";
        }
        field(21001510;Dim3;Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('КОД ОБЪЕКТА'),
                                                          "Dim 3"=CONST(true));
        }
        field(21001511;Dim3Compl;Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('КОД ОБЪЕКТА'));
        }
        field(21001512;Dim3BN;Code[20])
        {
            Caption = 'Код Объекта Бал Невест';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('КОД ОБЪЕКТА'));
        }
        field(21007419;"Dimension For Pay In FJ";Code[20])
        {
            Caption = 'Dimension For Pay In FJ';
            TableRelation = Dimension.Code;
        }
        field(21007420;"Dimension Value For Bonus";Code[20])
        {
            Caption = 'Dimension Value For Bonus';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension For Pay In FJ"));
        }
        field(21007421;"Dimension Value For Money";Code[20])
        {
            Caption = 'Dimension Value For Money';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension For Pay In FJ"));
        }
        field(21007422;"Billiard External System";Integer)
        {
            Caption = 'Бильярд Внешняя Система';
            TableRelation = "Restaurant External System";
        }
        field(21007423;"Bowling External System";Integer)
        {
            Caption = 'Боулинг Внешняя Система';
            TableRelation = "Restaurant External System";
        }
        field(21007424;"Wi-Fi External System";Integer)
        {
            Caption = 'Wi-Fi Внешняя Система';
            TableRelation = "Restaurant External System";
        }
        field(21007426;"Edit Class.";Boolean)
        {
            Caption = 'Редактировать Классификатор';
            Description = 'yuri 271014';
        }
        field(21007427;"Deposit Emp No.";Code[20])
        {
            Caption = 'Сотрудник Закрытие Депозит';
            Description = 'yuri 230315';
            TableRelation = "_Сотрудник Ресторана";
        }
        field(21007428;"CB Emp No.";Code[20])
        {
            Caption = 'Сотрудник Закрытие Банкет';
            Description = 'yuri 080615';
            TableRelation = "_Сотрудник Ресторана";
        }
        field(21007429;"Man.Class.Hookah";Code[50])
        {
            Caption = 'Мен. Класс. Кальян';
            Description = 'yuri 290615';
            TableRelation = "Классификация Группа"."Код" WHERE ("Принадлежит Упр"=CONST(true));
            ValidateTableRelation = false;
        }
        field(21007430;"Show Emp No.";Code[20])
        {
            Caption = 'Сотрудник Закрытие Шоу';
            Description = 'yuri 150119';
            TableRelation = "_Сотрудник Ресторана";
        }
    }

    keys
    {
        key(Key1;"Ключ")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "СотрудникРесторана": Record "_Сотрудник Ресторана";
        RestFunc: Codeunit "_Ресторан Доп. Функции";
}

