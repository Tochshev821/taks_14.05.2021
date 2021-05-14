OBJECT Table 21001401 _Заказ Ресторана Строка
{
  OBJECT-PROPERTIES
  {
    Date=15.03.21;
    Time=11:59:02;
    Modified=Yes;
    Version List=KRF,MBR;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    OnInsert=VAR
               _recLine@1000000000 : Record 21001401;
               _recMenuLine@1000000001 : Record 21006014;
               Item@1000000002 : Record 27;
             BEGIN
               IF "Строка Но." = 0 THEN BEGIN
                 _recLine.SETRANGE("Заказ Но.", "Заказ Но.");
                 IF _recLine.FINDLAST THEN
                   "Строка Но." := _recLine."Строка Но." + 10
                 ELSE
                   "Строка Но." := 10;
               END;

               //yuri 040216 >
               //выделяем бизнес ланчи
               IF _recMenuLine.GET("Меню Но.","Код Блюда","Номер Позиции В Меню","Тип позиции") THEN BEGIN
                 _recMenuLine.CALCFIELDS("Lunch Item");
                 IF _recMenuLine."Lunch Item" THEN BEGIN
                   VALIDATE("Main Line For Lunch", "Строка Но.");
                   VALIDATE("Признак Заказа", "Признак Заказа" :: "Бизнес Ланч");
                 END;
               END;
               //yuri 040216 <
               //apik 151020 (270316) параметры
               // PreserveParams - для создания заказов сразу с заданными извне параметрами
               IF NOT PreserveParams THEN
                 IF "Тип позиции" = "Тип позиции"::Товар THEN
                   CopyMenuParams;
               //apik 151020 (270316) параметры
             END;

    OnModify=BEGIN
               //apik 151020 (270316) параметры
               // PreserveParams - для создания заказов сразу с заданными извне параметрами
               IF ("Код Блюда"<> xRec."Код Блюда") THEN
                 IF NOT PreserveParams THEN  BEGIN
                   DeleteLineParams;
                   IF "Тип позиции" = "Тип позиции"::Товар THEN
                     CopyMenuParams;
                 END;
               //apik 151020 (270316) параметры
             END;

    OnDelete=VAR
               _recLine@1000000000 : Record 21001401;
             BEGIN
               IF ("Признак Заказа" = "Признак Заказа"::"Бизнес Ланч") AND ("Строка Но." = "Main Line For Lunch") THEN BEGIN
                 _recLine.SETRANGE("Заказ Но.", "Заказ Но.");
                 _recLine.SETRANGE("Признак Заказа",_recLine."Признак Заказа"::"Бизнес Ланч");
                 _recLine.SETRANGE("Main Line For Lunch", "Строка Но.");
                 _recLine.SETFILTER("Строка Но.", '<>%1',"Строка Но.");
                 _recLine.SETRANGE("Статус Блюда", _recLine."Статус Блюда" :: Выбрано);
                 _recLine.DELETEALL;
               END;
               //apik 151020 (270316) параметры
                 DeleteLineParams;
               //apik 151020 (270316) параметры
             END;

    LookupFormID=Form21001468;
    DrillDownFormID=Form21001468;
  }
  FIELDS
  {
    { 1   ;   ;Заказ Но.           ;Code20         }
    { 2   ;   ;Код Блюда           ;Code10        ;TableRelation=IF (Тип позиции=CONST(Товар)) Item
                                                                 ELSE IF (Тип позиции=CONST(Ресурс)) Resource;
                                                   OnValidate=BEGIN
                                                                CLEAR("Менеджер Группа Классификации");
                                                                IF Блюда.GET("Код Блюда") THEN BEGIN
                                                                  "Ресторан Блюдо Но." := Блюда."Ресторан Блюдо Но.";
                                                                  IF Название = '' THEN
                                                                    Название := Блюда.Description;   //если пустое - перезаписываем
                                                                  "Код Единицы Измерения" := Блюда."Base Unit of Measure";
                                                                  "Менеджер Группа Классификации" := Блюда."Менеджер Группа Классификации";
                                                                END;

                                                                ЗаказРесторанаЗаголовок.RESET;
                                                                ЗаказРесторанаЗаголовок.SETRANGE("Заказ Но.","Заказ Но.");
                                                                IF ЗаказРесторанаЗаголовок.FINDFIRST THEN BEGIN
                                                                  УчтМенюСтрока.RESET;
                                                                  УчтМенюСтрока.SETRANGE("Документ Но.","Меню Но.");
                                                                  УчтМенюСтрока.SETRANGE("Товар Но.","Код Блюда");
                                                                  УчтМенюСтрока.SETRANGE("Строка Но.","Номер Позиции В Меню");
                                                                  УчтМенюСтрока.SETRANGE(Блокировано, FALSE);
                                                                  IF NOT УчтМенюСтрока.FINDLAST THEN
                                                                    УчтМенюСтрока.SETRANGE("Строка Но.");
                                                                  IF УчтМенюСтрока.FINDLAST THEN BEGIN
                                                                    "Цена Единицы" := УчтМенюСтрока."Цена Продажи Руб";
                                                                    Сумма := УчтМенюСтрока."Цена Продажи Руб";
                                                                    "Код Единицы Измерения" := УчтМенюСтрока."Код Единицы Измерения";
                                                                    Название := УчтМенюСтрока."Блюдо Название";
                                                                    //Очередь := УчтМенюСтрока."Course No.";
                                                                  END;

                                                                  IF "Дата Заказа" = 0D THEN
                                                                    "Дата Заказа" := WORKDATE;
                                                                  IF "Время Заказа" = 0T THEN
                                                                    "Время Заказа" := TIME;
                                                                  "Код Отдела Блюда" := ЗаказРесторанаЗаголовок."Код Отдела";
                                                                  IF (ЗаказРесторанаЗаголовок."Дата Начала Заказа" = 0D) THEN BEGIN
                                                                    ЗаказРесторанаЗаголовок."Дата Начала Заказа" := WORKDATE;
                                                                    ЗаказРесторанаЗаголовок."Время Начала Заказа" := TIME;
                                                                  END;
                                                                  IF ЗаказРесторанаЗаголовок."Дата Окончания Заказа" <> WORKDATE THEN
                                                                    ЗаказРесторанаЗаголовок."Дата Окончания Заказа" := WORKDATE;
                                                                  ЗаказРесторанаЗаголовок."Время Окончания Заказа" := TIME;
                                                                  ЗаказРесторанаЗаголовок.MODIFY;

                                                                  IF "Код Зала Продажи" = '' THEN
                                                                    "Код Зала Продажи" := ЗаказРесторанаЗаголовок."Код Зала Продажи";
                                                                  DiscountMgt.FindDisc(CREATEDATETIME("Дата Заказа","Время Заказа"),Rec);
                                                                  IF "Discount Code" <> '' THEN
                                                                    IF DiscountCode.GET("Discount Code") THEN
                                                                     IF DiscountCode."Price Change" THEN BEGIN
                                                                      RoundIt := RoundMethod.GET(DiscountCode."Rounding Method");
                                                                      DiscAmount := "Цена Единицы" * "Discount %" / 100;
                                                                      "Цена Единицы" -= DiscAmount;
                                                                      IF RoundIt THEN
                                                                        "Цена Единицы" := RoundMethod.RoundAmount("Цена Единицы");
                                                                      IF "Цена Единицы" < 0 THEN
                                                                        "Цена Единицы" := 0;
                                                                     END;
                                                                  VALIDATE("Цена Единицы");
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Название            ;Text30        ;FieldClass=Normal }
    { 4   ;   ;Название 2          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Item."Description 2" WHERE (No.=FIELD(Заказ Но.))) }
    { 5   ;   ;Количество          ;Decimal       ;OnValidate=BEGIN
                                                                Количество := ROUND(Количество,0.001);
                                                                //apik VALIDATE(Сумма);
                                                                //apik 200716 (164531) > скидки
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < скидки
                                                              END;

                                                   DecimalPlaces=0:6 }
    { 6   ;   ;Сумма               ;Decimal       ;OnValidate=BEGIN
                                                                //Сумма := ROUND("Цена Единицы" * Количество,0.01);
                                                                //ClubBonusPriceSumm := ROUND(Количество * ClubBonusPrice,0.01);
                                                              END;
                                                               }
    { 7   ;   ;Строка Но.          ;Integer       ;InitValue=0 }
    { 8   ;   ;Цена Единицы        ;Decimal       ;OnValidate=BEGIN
                                                                //apik VALIDATE(Сумма);
                                                                //apik 200716 (164531) > скидки
                                                                GetGSetup;
                                                                ClubBonusPrice := ConvBonusKCY("Цена Единицы",TODAY);
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < скидки
                                                              END;
                                                               }
    { 9   ;   ;Внешний Заказ Но.   ;Code20         }
    { 10  ;   ;Статус Блюда        ;Option        ;OptionString=Заказано,Отменено,Перемещено,Выбрано }
    { 11  ;   ;Причина Списания    ;Option        ;OptionString=[ ,Списание,Возврат,Ошибка Официанта,ваучер] }
    { 12  ;   ;Время Отмены Блюда  ;Time           }
    { 13  ;   ;Менеджер Отмена Но. ;Code10         }
    { 14  ;   ;Менеджер Разделение Но.;Code10      }
    { 15  ;   ;Менеджер Изменение Гостей Но.;Code10 }
    { 16  ;   ;Менеджер Смена Официанта Но.;Code10 }
    { 17  ;   ;Менеджер Переноса на Др. Стол;Code10 }
    { 18  ;   ;Менеджер Блюда Откр. Цена;Code10    }
    { 19  ;   ;Причина Отмены      ;Option        ;OptionCaptionML=RUS=Отказ Клиента,Ошибка Официанта,Ошибка Повара,Долгое Приготовление,Стоп-Лист,Гость Изменил Заказ,Перебито По Сервис Меню,Перебито По Обычному Меню,Слив остатков,Промывка системы,Сбой пролайна,Тест;
                                                   OptionString=Отказ Клиента,Ошибка Официанта,Ошибка Повара,Долгое Приготовление,Стоп-Лист,Гость Изменил Заказ,Перебито По Сервис Меню,Перебито По Обычному Меню,Слив остатков,Промывка системы,Сбой пролайна,Тест }
    { 20  ;   ;Код Единицы Измерения;Code10       ;TableRelation="Unit of Measure" }
    { 21  ;   ;Ресторан Блюдо Но.  ;Text4          }
    { 22  ;   ;Смена Принтера      ;Integer        }
    { 23  ;   ;Дата Заказа         ;Date           }
    { 24  ;   ;Время Заказа        ;Time           }
    { 25  ;   ;Дата Оплаты         ;Date           }
    { 26  ;   ;Время Оплаты        ;Time           }
    { 1000;   ;Код Зала Приготовления;Code10      ;TableRelation="KR Hall";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Код Зала Продажи","Код Зала Приготовления");
                                                              END;
                                                               }
    { 1001;   ;Бронирование Но.    ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_Учт. Заказ Ресторана Заголово"."Бронирование Но." WHERE (Заказ Но.=FIELD(Заказ Но.))) }
    { 1002;   ;Комната Но.         ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_Учт. Заказ Ресторана Заголово"."Комната Гостя Но." WHERE (Заказ Но.=FIELD(Заказ Но.))) }
    { 50010;  ;Код Отдела Блюда    ;Code10         }
    { 50011;  ;Код Проекта Блюда   ;Code10         }
    { 50012;  ;Код Зала Продажи    ;Code10        ;TableRelation="KR Hall";
                                                   OnValidate=BEGIN
                                                                IF NOT РесторанЗалы.GET("Код Зала Продажи") THEN
                                                                  CLEAR(РесторанЗалы);

                                                                //yuri 160715
                                                                "Sales Company" := РесторанЗалы.GetSalesCompany;
                                                              END;
                                                               }
    { 50016;  ;Перенесено Из Другой Смены;Boolean ;InitValue=No }
    { 50023;  ;Мероприятие Но.     ;Code20         }
    { 50024;  ;Меню Но.            ;Code10        ;TableRelation="Учт. Меню Заголовок";
                                                   OnValidate=VAR
                                                                _recMenu@1000000000 : Record 21006013;
                                                              BEGIN
                                                                IF _recMenu.GET("Меню Но.") THEN BEGIN
                                                                  IF _recMenu."Menu Type" = _recMenu."Menu Type" :: Buffet THEN
                                                                    "Признак Заказа" := "Признак Заказа" ::"Шведский Стол"
                                                                  ELSE
                                                                    "Признак Заказа" := "Признак Заказа" ::"По Меню";
                                                                END
                                                                ELSE
                                                                  "Признак Заказа" := "Признак Заказа" ::"По Меню";
                                                              END;
                                                               }
    { 50025;  ;Питание Зал Строка Но.;Integer      }
    { 50026;  ;Питание Строка Но.  ;Integer        }
    { 50029;  ;Сумма Скидки        ;Decimal       ;InitValue=0 }
    { 50100;  ;Временно            ;Boolean        }
    { 50180;  ;Признак Заказа      ;Option        ;OnValidate=VAR
                                                                _recLine@1000000000 : Record 21001401;
                                                                _recLineNew@1000000003 : Record 21001401;
                                                                _recMenuLineLunch@1000000001 : Record 21026285;
                                                                _Qty@1000000004 : Decimal;
                                                                _recItem@1000000005 : Record 27;
                                                              BEGIN
                                                                IF ("Признак Заказа" = "Признак Заказа" :: "Бизнес Ланч") AND ("Строка Но." = "Main Line For Lunch") THEN BEGIN
                                                                  _recMenuLineLunch.SETRANGE("Документ Но.", "Меню Но.");
                                                                  _recMenuLineLunch.SETRANGE("Строка Но.", "Номер Позиции В Меню");
                                                                  _recMenuLineLunch.SETRANGE("Товар Но.", "Код Блюда");
                                                                  _recMenuLineLunch.SETRANGE("Тип позиции", "Тип позиции");
                                                                  _recMenuLineLunch.SETFILTER("Qty Item", '>%1',0);
                                                                  IF _recMenuLineLunch.FINDSET THEN
                                                                  REPEAT
                                                                    _recLine.SETRANGE("Заказ Но.", "Заказ Но.");
                                                                    _recLine.SETRANGE("Статус Блюда", _recLine."Статус Блюда" :: Выбрано);
                                                                    _recLine.SETRANGE("Меню Но.","Меню Но.");
                                                                    _recLine.SETFILTER("Признак Заказа", '<>%1',_recLine."Признак Заказа"::"Бизнес Ланч");
                                                                    IF _recMenuLineLunch."Max Amount" > 0 THEN
                                                                      _recLine.SETFILTER("Цена Единицы", '<=%1', _recMenuLineLunch."Max Amount");
                                                                    IF _recLine.FINDSET(TRUE) THEN
                                                                    REPEAT
                                                                      //_recMenuLine.SETRANGE("Документ Но.", _recLine."Меню Но.");
                                                                      //_recMenuLine.SETRANGE("Товар Но.", _recLine."Код Блюда");
                                                                      //_recMenuLine.SETRANGE("Строка Но.", _recLine."Номер Позиции В Меню");
                                                                      //_recMenuLine.SETRANGE("Тип позиции", _recLine."Тип позиции");
                                                                      //_recMenuLine.SETFILTER("Товар Группа Классификации", _recMenuLineLunch."Class.Filter");
                                                                      //IF _recMenuLine.FINDFIRST THEN BEGIN
                                                                      _recItem.SETRANGE("No.", _recLine."Код Блюда");
                                                                      _recItem.SETFILTER("Экран Группа Классификации",_recMenuLineLunch."Class.Filter");
                                                                      IF _recItem.FINDFIRST THEN BEGIN
                                                                        IF _recLine.Количество <= _recMenuLineLunch."Qty Item" THEN BEGIN
                                                                          _recLine.VALIDATE("Цена Единицы", 0);
                                                                          _recLine.VALIDATE("Main Line For Lunch", "Строка Но.");
                                                                          _recLine.VALIDATE("Признак Заказа", _recLine."Признак Заказа" ::"Бизнес Ланч");
                                                                          _recLine.MODIFY;
                                                                        END
                                                                        ELSE BEGIN
                                                                          _recLineNew.INIT;
                                                                          _recLineNew.TRANSFERFIELDS(_recLine);
                                                                          _recLineNew.VALIDATE("Строка Но.", _recLine."Строка Но." + 1000);
                                                                          _recLineNew.VALIDATE(Количество,_recLine.Количество - _recMenuLineLunch."Qty Item");
                                                                          _recLineNew.INSERT(TRUE);

                                                                          _recLine.VALIDATE(Количество, _recMenuLineLunch."Qty Item");
                                                                          _recLine.VALIDATE("Цена Единицы", 0);
                                                                          _recLine.VALIDATE("Main Line For Lunch", "Строка Но.");
                                                                          _recLine.VALIDATE("Признак Заказа", _recLine."Признак Заказа" ::"Бизнес Ланч");
                                                                          _recLine.MODIFY;
                                                                        END;

                                                                        _recMenuLineLunch."Qty Item" -= _recLine.Количество;
                                                                      END;
                                                                    UNTIL (_recLine.NEXT = 0) OR (_recMenuLineLunch."Qty Item" <= 0);
                                                                  UNTIL _recMenuLineLunch.NEXT = 0;
                                                                END;
                                                              END;

                                                   OptionString=По Меню,Бизнес Ланч,Шведский Стол;
                                                   Description=yuri 280815 }
    { 50200;  ;Очередь             ;Integer        }
    { 50201;  ;Комментарий         ;Text250        }
    { 50202;  ;Блюдо Подано        ;Boolean        }
    { 50300;  ;Гость Но.           ;Integer        }
    { 50302;  ;Source Type         ;Option        ;CaptionML=RUS=Тип Источника;
                                                   OptionCaptionML=RUS=терминал,планшет,электронное меню,сайт;
                                                   OptionString=terminal,tablet,emenu,web;
                                                   Description=yuri 191114 }
    { 50303;  ;Source Code         ;Text30        ;TableRelation=IF (Source Type=CONST(terminal)) "_Касса Ресторана Настройка".Код
                                                                 ELSE IF (Source Type=FILTER(tablet|emenu)) Devices.ID;
                                                   CaptionML=RUS=Код Источника;
                                                   Description=yuri 191114 }
    { 50304;  ;Trans. Round        ;Integer       ;CaptionML=RUS=Раунд Транзакций;
                                                   Description=yuri 191114 }
    { 50305;  ;Table No.           ;Integer       ;TableRelation="Ресторан Столики"."Столик Но.";
                                                   CaptionML=RUS=Столик Но.;
                                                   Description=yuri 241114 }
    { 50500;  ;Блюдо Приготовлено  ;Boolean       ;OnValidate=BEGIN
                                                                //apik 300420 (270316) > проверить, не готов ли заказ
                                                                GetOrderHeader;
                                                                MODIFY;
                                                                UpdateOrderReady;
                                                                //apik 300420 (270316) <
                                                              END;
                                                               }
    { 50501;  ;Hall Y-Shift        ;Integer       ;TableRelation=Y-Shifts;
                                                   CaptionML=RUS=Y-Смена Для Зала }
    { 50502;  ;Блюдо Из Группы     ;Code10        ;TableRelation="_Группа Блюд Заголовок" }
    { 50503;  ;Класс Блюда         ;Integer        }
    { 50504;  ;Location Y-Shift    ;Integer       ;TableRelation=Y-Shifts;
                                                   CaptionML=RUS=Y-Смена Для Склада }
    { 50510;  ;Раунд Номер         ;Integer        }
    { 50517;  ;Код Склада Списания ;Code10        ;TableRelation=Location;
                                                   OnValidate=VAR
                                                                _recLC@1000000000 : Record 14;
                                                              BEGIN
                                                                UpdateLocation();

                                                                "Owner Company" := GetOwnerCompanyId("Sales Company","Код Склада Списания");
                                                              END;
                                                               }
    { 50520;  ;Код Ячейки          ;Code10        ;OnValidate=BEGIN
                                                                UpdateLocation();
                                                              END;
                                                               }
    { 50521;  ;Перенесена Из Заказа Но.;Code20     }
    { 50522;  ;Перенесена В Заказа Но.;Code20      }
    { 50523;  ;Номер Позиции В Меню;Integer        }
    { 50550;  ;Тип позиции         ;Option        ;OptionString=Товар,Ресурс }
    { 50551;  ;Блок Услуги системы ;Boolean        }
    { 50552;  ;Код системы         ;Integer       ;TableRelation="Restaurant External System" }
    { 50555;  ;Цифровая Подпись Клиента;Code10     }
    { 50556;  ;Код Услуги          ;Code10        ;TableRelation="Service Type" }
    { 50557;  ;DiscountCard        ;Text30         }
    { 51002;  ;Позиция Выдана      ;Boolean        }
    { 52003;  ;Перенос стола       ;Integer       ;Description=Бильярд смена стола }
    { 52004;  ;Чек Боулинга        ;Integer       ;Description=Связь услуги с боулингом }
    { 52005;  ;Код Системы Боулинга;Integer        }
    { 52006;  ;ClubBonusPrice      ;Decimal        }
    { 52007;  ;ClubBonusPriceSumm  ;Decimal        }
    { 52008;  ;ClubBonusAmount     ;Decimal        }
    { 52009;  ;СреднСебест         ;Decimal        }
    { 52010;  ;Tariff Extra System ;Code10        ;TableRelation="Wi-Fi Tariff".Code WHERE (Source Type=CONST(RST));
                                                   CaptionML=RUS=Тариф Внешней Системы;
                                                   Description=yuri 120814 (76892) }
    { 52011;  ;Wi-Fi Job Upload    ;Integer       ;CaptionML=RUS=Wi-Fi Промокод;
                                                   Description=yuri 120814 (76892) }
    { 52012;  ;Main Line For Lunch ;Integer       ;CaptionML=RUS=Строка Ланча;
                                                   Description=yuri 040216 (128051) }
    { 52111;  ;Название Стола      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_Заказ Ресторана Заголовок".НазваниеСтола WHERE (Заказ Но.=FIELD(Заказ Но.))) }
    { 53003;  ;Питание Подробно Строка Но.;Integer;Description=VAN 130115 }
    { 54001;  ;dim8                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(КОНСОЛИДАЦИОННАЯ ЕД.));
                                                   OnLookup=VAR
                                                              _CUAdd@1101967000 : Codeunit 21001403;
                                                            BEGIN
                                                              _CUAdd.LookUpDim8(dim8);
                                                            END;

                                                   CaptionML=RUS=Консал. Ед. }
    { 54002;  ;Код Кассы           ;Code10        ;Description=yuri 100114 }
    { 54003;  ;Need MOL Order      ;Boolean       ;OnValidate=VAR
                                                                _RestManagerSetup@1000000000 : Record 21001400;
                                                                _Date@1000000001 : Date;
                                                                _recRestMOLLink@1000000002 : Record 21000006;
                                                              BEGIN
                                                                IF "Need MOL Order" THEN BEGIN
                                                                  _RestManagerSetup.GET();
                                                                  IF "Время Заказа" < _RestManagerSetup."Время сдвига отчетности" THEN
                                                                    _Date := "Дата Заказа" - 1
                                                                  ELSE
                                                                    _Date := "Дата Заказа";

                                                                  IF "Тип позиции" = "Тип позиции" :: Товар THEN
                                                                    IF ("Статус Блюда" = "Статус Блюда"::Заказано) OR
                                                                       ("Статус Блюда" = "Статус Блюда"::Отменено) AND NOT "Блюдо Приготовлено" THEN BEGIN
                                                                      _recRestMOLLink.INIT;
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
                                                                      _recRestMOLLink.INSERT(TRUE);

                                                                      "MOL Order No." := FORMAT(_recRestMOLLink.ID);
                                                                    END;

                                                                  IF "MOL Order No." = '' THEN
                                                                    "MOL Order No." := 'AAA';
                                                                END;
                                                              END;

                                                   CaptionML=RUS=Необходима Заявка;
                                                   Description=yuri 150517 }
    { 54004;  ;MOL Order No.       ;Code20        ;TableRelation="Order MOL Header";
                                                   CaptionML=RUS=Номер Заявки;
                                                   Description=yuri 150517 }
    { 69000;  ;Bonus Discount Amount;Decimal      ;CaptionML=[ENU=Bonus Discount Amount;
                                                              RUS=Сумма бонусной скидки];
                                                   Description=#36211 }
    { 69001;  ;Amount (ACY)        ;Decimal       ;CaptionML=[ENU=Amount (ACY);
                                                              RUS=Сумма (ДОВ)];
                                                   Description=76691 }
    { 69002;  ;Disc. Amount (ACY)  ;Decimal       ;CaptionML=[ENU=Disc. Amount (ACY);
                                                              RUS=Скидка (ДОВ)];
                                                   Description=76691 }
    { 69003;  ;Bonus Disc. Amount (ACY);Decimal   ;CaptionML=[ENU=Bonus Disc. Amount (ACY);
                                                              RUS=Бонус (ДОВ)];
                                                   Description=76691 }
    { 69004;  ;Менеджер Группа Классификации;Code20;
                                                   TableRelation="Классификация Группа".Код WHERE (Тип=CONST(Учетный),
                                                                                                   Принадлежит Упр=CONST(Yes));
                                                   Description=76691 }
    { 69006;  ;Discount Code       ;Code10        ;TableRelation="Discount Code";
                                                   OnValidate=BEGIN
                                                                IF "Discount Code" = '' THEN BEGIN
                                                                  CLEAR("Discount Rule No.");
                                                                  CLEAR("Discount %");
                                                                END;
                                                              END;

                                                   CaptionML=RUS=Код скидки }
    { 69007;  ;Discount Rule No.   ;Integer       ;TableRelation="Discount Rule";
                                                   CaptionML=[ENU=Rule No.;
                                                              RUS=Номер правила] }
    { 69008;  ;Discount %          ;Decimal       ;OnValidate=BEGIN
                                                                //apik 200716 (164531) > скидки
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < скидки
                                                              END;

                                                   CaptionML=[ENU=Discount %;
                                                              RUS=Скидка (%)];
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   AutoFormatType=2 }
    { 69009;  ;Parameter Code      ;Code10        ;TableRelation=Parameter;
                                                   CaptionML=[ENU=Code;
                                                              RUS=Код] }
    { 69018;  ;Sales Company       ;Integer       ;CaptionML=[ENU=Sales Company;
                                                              RUS=Продает фирма] }
    { 69019;  ;Owner Company       ;Integer       ;CaptionML=[ENU=Sales Company;
                                                              RUS=Владелец фирма] }
    { 69020;  ;Storno Line No.     ;Integer       ;InitValue=0;
                                                   CaptionML=RUS=Сторно строки Но. }
    { 21001400;;dim1               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 1=CONST(Yes));
                                                   CaptionML=RUS=Центр Учета }
    { 21001401;;dim2               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 2=CONST(Yes));
                                                   CaptionML=RUS=Статья Бюджета }
    { 21001402;;dim3               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 3=CONST(Yes));
                                                   CaptionML=RUS=Код Объекта }
    { 21001403;;dim4               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(ЕКТУ));
                                                   CaptionML=RUS=ЕКТУ }
    { 21001404;;dim5               ;Code20        ;CaptionML=RUS=Группа Сплит Меню }
    { 21001405;;dim6               ;Code20        ;TableRelation="_Сотрудник Ресторана".Но. WHERE (Но.=FIELD(dim6));
                                                   CaptionML=RUS=Официант }
    { 21001406;;Storno Order No.   ;Code20        ;CaptionML=RUS=Заказ Для Сторно }
    { 21001509;;Hotel Guest No.    ;Code20        ;TableRelation=Guests;
                                                   CaptionML=RUS=Гость Отеля Но. }
    { 21001512;;Dim1 for Cost      ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 1=CONST(Yes));
                                                   CaptionML=RUS=ЦУ для издержек;
                                                   Description=yuri 281117 }
    { 21001513;;Dim2 for Cost      ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 2=CONST(Yes));
                                                   CaptionML=RUS=СБ для издержек;
                                                   Description=yuri 281117 }
  }
  KEYS
  {
    {    ;Заказ Но.,Строка Но.                    ;SumIndexFields=Сумма,Сумма Скидки;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Заказ Но.,Внешний Заказ Но.,Статус Блюда;SumIndexFields=Сумма;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Код Блюда,Статус Блюда,Цена Единицы,Код Услуги;
                                                   SumIndexFields=Количество,Сумма Скидки,ClubBonusAmount;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Код Блюда,Статус Блюда,Цена Единицы,Раунд Номер;
                                                   SumIndexFields=Количество,Сумма Скидки;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Блюдо Из Группы,Класс Блюда,Статус Блюда;
                                                   SumIndexFields=Количество,Сумма;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Код Блюда,Блюдо Из Группы,Класс Блюда,Статус Блюда,Need MOL Order,MOL Order No.;
                                                   SumIndexFields=Количество;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Блюдо Из Группы,Статус Блюда  ;SumIndexFields=Сумма;
                                                   MaintainSIFTIndex=No }
    {    ;Очередь                                  }
    {    ;Раунд Номер                              }
    {    ;Заказ Но.,Код Блюда,Статус Блюда,Цена Единицы,Раунд Номер,Меню Но.,Номер Позиции В Меню;
                                                   SumIndexFields=Количество,Сумма Скидки;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Код Блюда,Статус Блюда,Цена Единицы,Меню Но.,Номер Позиции В Меню;
                                                   SumIndexFields=Количество,Сумма;
                                                   MaintainSIFTIndex=No }
    {    ;Заказ Но.,Гость Но.,Очередь,Строка Но.   }
    {    ;Дата Заказа,Время Заказа                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Сотрудник@1000000000 : Record 5200;
      УчтМенюЗаголовок@1000000001 : Record 21006013;
      УчтМенюСтрока@1000000002 : Record 21006014;
      ЗаказРесторанаЗаголовок@1000000003 : Record 21001417;
      Блюда@1000000004 : Record 27;
      РесторанЗалы@1000000005 : Record 21001418;
      ЗаказРесторанаСтрока@1000000007 : Record 21001401;
      CUAdd@1000000008 : Codeunit 21001403;
      DiscountMgt@1000000009 : Codeunit 21007071;
      DiscountCode@1000000010 : Record 21001516;
      RoundMethod@1000000011 : Record 42;
      DiscAmount@1000000012 : Decimal;
      RoundIt@1000000013 : Boolean;
      ClubGSetup@1000000018 : Record 21007451;
      CurrencyLoc@1000000017 : Record 4;
      CurrencyKOR@1000000016 : Record 4;
      GSetupRead@1000000015 : Boolean;
      CurrExchRate@1000000014 : Record 330;
      HS@1000000006 : Record 21007001;
      КассаНастройка@1000000020 : Record 21001415;
      PMSFunc@1000000019 : Codeunit 21002101;
      PreserveParams@1000000021 : Boolean;

    PROCEDURE SetDimentions@1000000000();
    VAR
      MenuHeader@1000000000 : Record 21006013;
      MenuLine@1000000001 : Record 21006014;
      GSetup@1000000002 : Record 21001400;
      halls@1000000003 : Record 21001418;
      header@1000000004 : Record 21001417;
      _DefDim@1101967000 : Record 352;
      _tProjectScheduler@1101967001 : Record 21001506;
      _RR@1000000005 : Record 21002128;
      _TEventHeader@1000000007 : Record 21002200;
      _TEventType@1000000006 : Record 21002219;
      Dim4Fixed@1000000008 : Boolean;
      _recDigSig@1000000009 : Record 21006032;
    BEGIN
      IF NOT GSetup.GET() THEN
        GSetup.INIT;
      header.GET("Заказ Но.");

      IF dim4 <> '' THEN
        Dim4Fixed := TRUE;

      //========================================================
      //КЕ
      dim8 := GSetup.Dim8;

      IF halls.GET("Код Зала Продажи") THEN BEGIN
        dim1 := halls.Dim1;
         IF halls."Fixed Dim4" THEN BEGIN
           Dim4Fixed := halls."Fixed Dim4";
           dim4 := halls.Dim4;
         END;

         IF _DefDim.GET(DATABASE::"KR Hall","Код Зала Продажи",GSetup."Shortcut Dimension 8 Code") THEN
            dim8 := _DefDim."Dimension Value Code";
      END;

      //========================================================
      //ЦУ
      IF MenuHeader.GET("Меню Но.") THEN
        IF MenuHeader.Dim1 <> '' THEN BEGIN
          dim1 := MenuHeader.Dim1;
          IF MenuHeader."Fixed Dim4" THEN BEGIN
            Dim4Fixed := MenuHeader."Fixed Dim4";
            dim4 := MenuHeader.Dim4;
          END;
        END;


      //========================================================
      //СТАТЬЯ БЮДЖЕТА
      IF MenuLine.GET("Меню Но.","Код Блюда","Номер Позиции В Меню","Тип позиции") THEN BEGIN
        dim2 := MenuLine.Dim2;
        dim5 := FORMAT(MenuLine.DimGroup);
      END;

      //========================================================
      //КОД ОБЪЕКТА
      dim3 := _tProjectScheduler.GetDim3("Код Зала Продажи",CREATEDATETIME("Дата Заказа","Время Заказа"));

      IF header.dim3 <> '' THEN
        dim3 := header.dim3;

      //========================================================
      //ЕКТУ
      IF NOT Dim4Fixed THEN BEGIN
        dim4 := GSetup.Dim4;
        IF MenuHeader.GET("Меню Но.") THEN
          IF MenuHeader.Dim4 <> '' THEN
            dim4 := MenuHeader.Dim4
          ELSE IF MenuHeader."Menu Type" = MenuHeader."Menu Type"::Service THEN
            dim4 := GSetup.Dim4Compl;
      END;
      IF MenuHeader.Dim3 <> '' THEN
        dim3 := MenuHeader.Dim3;
      IF MenuLine.Dim3 <> '' THEN
        dim3 := MenuLine.Dim3;
      IF (header."Бронирование Но." <> '') THEN BEGIN
        IF _TEventHeader.GET(header."Бронирование Но.") THEN BEGIN
          dim3 := _TEventHeader.dim3;

          IF NOT Dim4Fixed THEN BEGIN
            IF _TEventHeader.dim4 <> '' THEN
              dim4 := _TEventHeader.dim4
            ELSE IF _TEventType.GET(_TEventHeader."Вид Мероприятия") THEN
              dim4 := _TEventType."Dimension 4 Value";
          END
        END ELSE
          IF _RR.GET(header."Бронирование Но.") THEN
            IF _RR.dim3 <> '' THEN
              dim3 := _RR.dim3;

        IF NOT Dim4Fixed THEN
          //yuri 291117
          //IF (STRPOS(GSetup."Фильтр по Пеймастерам в отч.", header."Бронирование Но.") <> 0) OR
          //   (STRPOS(CUAdd.NOTServicePM("Код Зала Продажи"), header."Бронирование Но.") <> 0) THEN
          IF header."Цифровая Подпись Клиента" <> '' THEN
            dim4 := GSetup.Dim4Compl;
      END;

      //yuri 301117
      IF _recDigSig.GET(header."Цифровая Подпись Клиента") THEN BEGIN
        "Dim1 for Cost" := _recDigSig."Dim1 for Cost";
        "Dim2 for Cost" := _recDigSig."Dim2 for Cost";
      END;

      IF dim4 = GSetup.Dim4Compl THEN
        dim3 := '';
    END;

    PROCEDURE GetDocDimensions@1000000001(VAR TempDimDoc@1000000000 : Record 357);
    VAR
      GSetup@1000000001 : Record 21001400;
      GLSetup@1000000002 : Record 98;
    BEGIN
      //apik 280415 (104159) получить совместимые измерения
      GLSetup.GET;
      GSetup.GET;
      IF dim1 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GLSetup."Global Dimension 1 Code";
        TempDimDoc."Dimension Value Code" := dim1;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim3 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GLSetup."Global Dimension 2 Code";
        TempDimDoc."Dimension Value Code" := dim2;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim3 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 3 Code";
        TempDimDoc."Dimension Value Code" := dim3;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim4 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 4 Code";
        TempDimDoc."Dimension Value Code" := dim4;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim8 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 8 Code";
        TempDimDoc."Dimension Value Code" := dim8;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
    END;

    PROCEDURE GetOwnerCompanyId@1000000002(CompanyId@1000000003 : Integer;LocationCode@1000000000 : Code[20]) OwnerId : Integer;
    VAR
      recLocation@1000000004 : Record 14;
      recICPartner@1000000001 : Record 413;
      recCompany@1000000002 : Record 2000000006;
    BEGIN
      //apik 170715 получение номера фирмы хозяина товара
      OwnerId := CompanyId; //default
      IF PMSFunc.FindById(CompanyId,recCompany) THEN BEGIN
        recLocation.CHANGECOMPANY(recCompany.Name);
        recICPartner.CHANGECOMPANY(recCompany.Name);
        IF recLocation.GET(LocationCode) AND
          recICPartner.GET(recLocation."IC Partner Owner") AND
          (recICPartner."Inbox Type" = recICPartner."Inbox Type"::Database) AND
          recCompany.GET(recICPartner."Inbox Details") THEN
           OwnerId := recCompany."No.";
      END;
    END;

    PROCEDURE UpdateLocation@1000000006();
    VAR
      _recHallLocRepl@1000000000 : Record 21026288;
    BEGIN
      IF _recHallLocRepl.GET("Меню Но.", "Код Зала Продажи", "Код Склада Списания", "Код Ячейки") THEN BEGIN
        "Код Склада Списания" := _recHallLocRepl."New Location Code";
        "Код Ячейки" := _recHallLocRepl."New Bin Code";
      END;
    END;

    PROCEDURE UpdateAmounts@1000000003();
    BEGIN
      //apik 200716 (164531) скидки
      Сумма := ROUND(Количество * "Цена Единицы",0.01);
      ClubBonusPriceSumm := ROUND(Количество * ClubBonusPrice,0.01);
      IF "Discount Code" <> '' THEN
        IF DiscountCode.GET("Discount Code") THEN
        IF NOT DiscountCode."Price Change" THEN BEGIN
          RoundIt := RoundMethod.GET(DiscountCode."Rounding Method");
          DiscAmount := Сумма * "Discount %" / 100;
          IF RoundIt THEN
            DiscAmount := RoundMethod.RoundAmount(DiscAmount);
          "Сумма Скидки" := DiscAmount;
        END;
    END;

    PROCEDURE GetGSetup@1101967001();
    VAR
      _cuKR@1000000000 : Codeunit 21002204;
    BEGIN
      //apik 271213 (36211) читаем настройки бонусов
      IF NOT GSetupRead THEN BEGIN
        КассаНастройка.RESET;
        КассаНастройка.SETRANGE("Терминал Но.", _cuKR.GetComputerName);
        КассаНастройка.SETRANGE("Код Зала","Код Зала Продажи");
        IF NOT КассаНастройка.FINDFIRST THEN
          CLEAR(КассаНастройка);

        IF КассаНастройка."Касса Клон" <> '' THEN BEGIN
           КассаНастройка.RESET;
           КассаНастройка.SETRANGE(Код,КассаНастройка."Касса Клон");
           КассаНастройка.SETRANGE("Терминал Но.", _cuKR.GetComputerName);
           IF NOT КассаНастройка.FINDFIRST THEN
             CLEAR(КассаНастройка);
        END;
        HS.GetLocal;
        IF КассаНастройка.Код = '' THEN
          КассаНастройка.ClubRegin := HS."Club Region Code";
        CLEAR(ClubGSetup);

        IF КассаНастройка.ClubRegin <> '' THEN
          ClubGSetup.GET(КассаНастройка.ClubRegin)
        ELSE
          ClubGSetup.FINDFIRST;

      //  BonusActive := ClubGSetup."Bonus Service Type" <> '';
        CurrencyLoc.InitRoundingPrecision;
        CurrencyKOR.InitRoundingPrecision;
        IF CurrencyKOR.GET(ClubGSetup."Bonus Currency Code") THEN;
        GSetupRead := TRUE;
      END;
    END;

    PROCEDURE ConvBonusLCY@1000000063(AmtKCY@1000000000 : Decimal;aDate@1000000001 : Date) AmtLCY : Decimal;
    BEGIN
      //apik 051113 (53158)
      //assert: сетап клуба прочитан
      AmtLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(aDate,ClubGSetup."Bonus Currency Code",AmtKCY,
         CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
         CurrencyLoc."Amount Rounding Precision");
    END;

    PROCEDURE ConvBonusKCY@1000000064(AmtLCY@1000000000 : Decimal;aDate@1000000001 : Date) AmtKCY : Decimal;
    BEGIN
      //apik 051113 (53158)
      //assert: сетап клуба прочитан
      AmtKCY := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(aDate,ClubGSetup."Bonus Currency Code",AmtLCY,
         CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
         CurrencyKOR."Amount Rounding Precision");
    END;

    PROCEDURE GetOrderHeader@1000000005();
    BEGIN
      IF ЗаказРесторанаЗаголовок."Заказ Но." <> "Заказ Но." THEN
        IF NOT ЗаказРесторанаЗаголовок.GET("Заказ Но.") THEN
          CLEAR(ЗаказРесторанаЗаголовок);
    END;

    PROCEDURE UpdateOrderReady@1000000004();
    VAR
      ROL@1000000000 : Record 21001401;
      AllItemsReady@1000000001 : Boolean;
    BEGIN
      ROL.SETRANGE("Заказ Но.", "Заказ Но.");
      ROL.SETFILTER("Статус Блюда", '<>%1', ROL."Статус Блюда"::Отменено);
      ROL.SETRANGE("Тип позиции", ROL."Тип позиции"::Товар);
      ROL.SETRANGE("Блюдо Приготовлено", FALSE);
      AllItemsReady := ROL.ISEMPTY;
      IF ЗаказРесторанаЗаголовок."Статус Заказа" = ЗаказРесторанаЗаголовок."Статус Заказа"::Заказано THEN BEGIN
          IF AllItemsReady THEN BEGIN
            ЗаказРесторанаЗаголовок."Статус Заказа" := ЗаказРесторанаЗаголовок."Статус Заказа"::Готово;
            ЗаказРесторанаЗаголовок.MODIFY;
          END;
      END ELSE
        IF ЗаказРесторанаЗаголовок."Статус Заказа" = ЗаказРесторанаЗаголовок."Статус Заказа"::Готово THEN
          IF NOT AllItemsReady THEN BEGIN
            ЗаказРесторанаЗаголовок."Статус Заказа" := ЗаказРесторанаЗаголовок."Статус Заказа"::Заказано;
            ЗаказРесторанаЗаголовок.MODIFY;
          END;
    END;

    PROCEDURE CalcColor@1000000007() : Integer;
    VAR
      _recItem@1000000000 : Record 27;
      _ColorRed@1000000001 : Integer;
      _ColorYellow@1000000002 : Integer;
      _ColorBlue@1000000003 : Integer;
      _ColorBlack@1000000004 : Integer;
    BEGIN
      //yuri 170914  >
      _ColorRed := 1000;
      _ColorYellow := 98498;
      _ColorBlack := 0;
      _ColorBlue := 16711680;

      CASE "Статус Блюда" OF
        "Статус Блюда" :: Заказано :
          BEGIN
            IF _recItem.GET("Код Блюда") AND _recItem."Блюдо с открытой ценой" THEN
              EXIT(_ColorYellow);
            EXIT(_ColorBlack);
          END;
        "Статус Блюда" :: Отменено :
          EXIT(_ColorRed);
        ELSE
          EXIT(_ColorBlack);
      END;
      //yuri 170914 <
    END;

    PROCEDURE CopyMenuParams@1000000009();
    VAR
      OrderParams@1000000000 : Record 21000725;
      MenuParms@1000000001 : Record 21000724;
      ParamOpt@1000000002 : Record 21000722;
      MenuLine@1000000003 : Record 21006014;
    BEGIN
      //apik 161020 (270316) параметры
      GetOrderHeader;
      MenuParms.SETRANGE("Меню Но.", "Меню Но.");
      MenuParms.SETRANGE("Меню Товар Но.", "Код Блюда");
      MenuParms.SETRANGE("Меню строка Но.", "Номер Позиции В Меню");
      MenuParms.SETRANGE("Меню тип позиции", "Тип позиции");
      IF MenuParms.FINDSET THEN
      REPEAT
        OrderParams.INIT;
        OrderParams."Заказ Но." := "Заказ Но.";
        OrderParams."Строка Но." := "Строка Но.";
        OrderParams."Parameter Code" := MenuParms."Parameter Code";
        OrderParams."Parameter Description" := MenuParms."Parameter Description";
        OrderParams."Parameter Type" := MenuParms."Parameter Type";
        OrderParams."Parameter Flag" := MenuParms."Parameter Flag";
        OrderParams."Меню Но." := "Меню Но.";
        OrderParams."Option Quantity" := 1;
        OrderParams.VALIDATE("Parameter Value", MenuParms."Parameter Value");
        IF OrderParams."Parameter Type" IN
          [OrderParams."Parameter Type"::"Item Option"..OrderParams."Parameter Type"::"Resource Option"] THEN BEGIN
            IF ParamOpt.GET(OrderParams."Parameter Code", OrderParams."Parameter Option") THEN
              OrderParams."Option Quantity" := ParamOpt.Quantity;
            AddParamOrderLine(Rec, OrderParams);
        END;
        OrderParams.INSERT(TRUE);
      UNTIL MenuParms.NEXT = 0;
    END;

    PROCEDURE DeleteLineParams@1000000010();
    VAR
      LineParms@1000000001 : Record 21000725;
    BEGIN
      //apik 161020 (270316) параметры
      LineParms.SETRANGE("Заказ Но.", "Заказ Но.");
      LineParms.SETRANGE("Строка Но.", "Строка Но.");
      IF NOT LineParms.ISEMPTY THEN
        LineParms.DELETEALL(TRUE);
    END;

    PROCEDURE AddParamOrderLine@1000000008(ROL@1000000000 : Record 21001401;VAR OrderParams@1000000001 : Record 21000725);
    VAR
      NewLineNo@1000000002 : Integer;
      NewROL@1000000003 : Record 21001401;
      MenuLine@1000000004 : Record 21006014;
    BEGIN
      //apik 161020 (270316) параметры
      GetOrderHeader;
      IF NOT MenuLine.GET(ROL."Меню Но.",OrderParams."Доп. Товар Но.",
        OrderParams."Меню строка Но.",OrderParams."Доп. тип позиции") THEN EXIT;
      IF MenuLine.Блокировано THEN EXIT;
      IF ЗаказРесторанаЗаголовок."Дата Начала Заказа" < MenuLine."Меню на Дату" THEN EXIT;
      IF (MenuLine."Меню до Даты" <> 0D) AND
         (ЗаказРесторанаЗаголовок."Дата Начала Заказа" > MenuLine."Меню до Даты") THEN EXIT;

      NewROL.SETRANGE("Заказ Но.", "Заказ Но.");
      IF NewROL.FINDLAST THEN
        NewLineNo := NewROL."Строка Но.";
      IF NewLineNo < ROL."Строка Но." THEN  // на случай невставленной ведущей строки
        NewLineNo := ROL."Строка Но.";
      NewLineNo += 10;

      NewROL := ROL; // копировать общую бодягу
      NewROL."Строка Но." := NewLineNo;
      NewROL."Тип позиции" := OrderParams."Доп. тип позиции";
      NewROL."Номер Позиции В Меню" := OrderParams."Меню строка Но.";
      NewROL."Код Единицы Измерения" := MenuLine."Код Единицы Измерения";
      NewROL.VALIDATE("Код Блюда", OrderParams."Доп. Товар Но.");
      NewROL.VALIDATE("Цена Единицы", 0);
      NewROL.VALIDATE(Количество, OrderParams."Option Quantity" * ROL.Количество);
      NewROL.Название := COPYSTR(MenuLine."Блюдо Название",1,30);
      NewROL.СреднСебест := MenuLine.РасчетнаяСебест;
      NewROL.VALIDATE("Код Склада Списания", MenuLine."Код Склада Списания");
      NewROL.VALIDATE("Код Ячейки", MenuLine."Код Ячейки");
      NewROL."Main Line For Lunch" := ROL."Строка Но.";
      NewROL.INSERT;

      OrderParams."Доп. строка Но." := NewLineNo;
    END;

    PROCEDURE ShowParameters@1000000011();
    VAR
      OrderParams@1000000000 : Record 21000725;
    BEGIN
      OrderParams.SETRANGE("Заказ Но.", "Заказ Но.");
      OrderParams.SETRANGE("Строка Но.", "Строка Но.");
      FORM.RUNMODAL(0, OrderParams);
    END;

    PROCEDURE SetPreserveParams@1000000012(aFlag@1000000000 : Boolean);
    BEGIN
      PreserveParams := aFlag;
    END;

    PROCEDURE UpdateParametersFrom@1000000013(VAR TempOLP@1000000000 : Record 21000725);
    VAR
      OrderParams@1000000001 : Record 21000725;
      ParamOpt@1000000002 : Record 21000722;
    BEGIN
      //apik 211020 (270316) параметры из внешней таблицы (считаем отфильтрованной)
      DeleteLineParams;
      IF "Тип позиции" <> "Тип позиции"::Товар THEN EXIT;

      GetOrderHeader;
      IF TempOLP.FINDSET THEN
      REPEAT
        OrderParams.INIT;
        OrderParams."Заказ Но." := "Заказ Но.";
        OrderParams."Строка Но." := "Строка Но.";
        OrderParams.VALIDATE("Parameter Code", TempOLP."Parameter Code");
        OrderParams.VALIDATE("Parameter Flag", TempOLP."Parameter Flag");
        OrderParams."Parameter Description" := TempOLP."Parameter Description";
        OrderParams."Меню Но." := "Меню Но.";
        OrderParams."Option Quantity" := 1;
        OrderParams.VALIDATE("Parameter Option", TempOLP."Parameter Option");
        IF OrderParams."Parameter Type" IN
          [OrderParams."Parameter Type"::"Item Option"..OrderParams."Parameter Type"::"Resource Option"] THEN BEGIN
            IF ParamOpt.GET(OrderParams."Parameter Code", OrderParams."Parameter Option") THEN
              OrderParams."Option Quantity" := ParamOpt.Quantity;
            AddParamOrderLine(Rec, OrderParams);
        END;
        OrderParams.INSERT(TRUE);
      UNTIL TempOLP.NEXT = 0;
    END;

    BEGIN
    {
      yuri > 28.05.13 + Dim8 Консал. Ед.
      apik 251214 (91420) Наследование поля Dim3 (код объекта) из меню
      apik 280415 (104159) добавлена логика фиксированных ЕКТУ
      VAN 130115 Добавлено поле "Питание Подробно Строка Но."
      apik 200716 (164579) +опции в поле Причина Отмены
      apik 200716 (164531) скидки
              ЗаказРесторанаСтрока."Цена Единицы" := D;
              ЗаказРесторанаСтрока.VALIDATE(Сумма, ROUND(_КолвоБлюда * D,0.01));
              ЗаказРесторанаСтрока.ClubBonusPrice := ConvBonusKCY(ЗаказРесторанаСтрока."Цена Единицы",TODAY);
              ЗаказРесторанаСтрока.ClubBonusPriceSumm := ConvBonusKCY(ЗаказРесторанаСтрока.Сумма,TODAY);
    }
    END.
  }
}

