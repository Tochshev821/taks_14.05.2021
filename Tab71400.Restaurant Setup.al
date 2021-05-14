OBJECT Table 21001400 Менеджер Ресторана Настройка
{
  OBJECT-PROPERTIES
  {
    Date=15.01.19;
    Time=12:06:25;
    Modified=Yes;
    Version List=KRF,res,CK;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    { 1   ;   ;Ключ                ;Code10        ;TableRelation="KR Hall" }
    { 2   ;   ;Сотрудник Ресторана Серия Но.;Code20;
                                                   TableRelation="No. Series" }
    { 3   ;   ;ПО Магия            ;Boolean        }
    { 4   ;   ;ПО RKeeper          ;Boolean        }
    { 5   ;   ;Тип Передачи Данных ;Option        ;OptionString=Через Промежуточные Таблицы NF,Напрямую в Таблицы ПО }
    { 6   ;   ;Комлекс. Питание Серия Номеров;Code20;
                                                   TableRelation="No. Series" }
    { 7   ;   ;Тип Регистрации Персонала;Option   ;OptionString=Код,Ключ,Карта }
    { 8   ;   ;Предв. Заказ Рест. Серия Но.;Code20;TableRelation="No. Series" }
    { 9   ;   ;Код Измерения для Класс. Блюд;Code20;
                                                   TableRelation=Item }
    { 10  ;   ;Удалять Заказ при Полном Перем;Boolean }
    { 11  ;   ;Создав. Новый Заказ при Перещ.;Boolean }
    { 13  ;   ;Фин. Журнал Код Шаблона;Code10     ;TableRelation="Gen. Journal Template".Name }
    { 14  ;   ;Фин. Журнал Код Раздел;Code10      ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Фин. Журнал Код Шаблона)) }
    { 15  ;   ;Проводить По Бухгалтерии;Option    ;OptionString=Суммарно,По Отделам и Проектам }
    { 18  ;   ;Оплаты Ресторана Серия Номеров;Code20;
                                                   TableRelation="No. Series" }
    { 19  ;   ;Касса Ресторана     ;Code10        ;TableRelation="Bank Account".No. }
    { 20  ;   ;Тип Регистрации Гостя;Option       ;OptionString=Код,Карта }
    { 21  ;   ;Тип Расчета в Баре  ;Option        ;OptionString=Без Вариантов,С Вариантами }
    { 22  ;   ;Тип Передачи в Счет Гостя;Option   ;OptionString=По Номеру Комнаты,По Номеру Бронирования }
    { 24  ;   ;Счет Но.            ;Code10        ;TableRelation="No. Series" }
    { 25  ;   ;Учт. Счет Но.       ;Code10        ;TableRelation="No. Series" }
    { 26  ;   ;Тип Суммирования    ;Option        ;OptionString=[ ,По Блюдам] }
    { 27  ;   ;База Источник       ;Boolean        }
    { 28  ;   ;Менеджер Ресторана  ;Text5          }
    { 29  ;   ;Формиров. Гость Услуга Строка;Boolean }
    { 51  ;   ;Фин. Журнал Код Шаблона Агент;Code10;
                                                   TableRelation="Gen. Journal Template".Name }
    { 52  ;   ;Фин. Журнал Код Раздел Агент;Code10;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Фин. Журнал Код Шаблона Агент)) }
    { 53  ;   ;Агент Поставщик Но. ;Code20        ;TableRelation=Vendor }
    { 54  ;   ;Агент Учетная Группа;Code20        ;TableRelation="Vendor Posting Group".Code }
    { 50000;  ;Кред. Карта Клише   ;Code20        ;CaptionML=RUS=Кред. Карты КЛИШЕ }
    { 50001;  ;Кред. Карта Клише (Амер. Эксп);Code20;
                                                   CaptionML=RUS=Кред. Карты КЛИШЕ (Am.Exp.) }
    { 50002;  ;Карточка Позиция Начало;Integer     }
    { 50003;  ;Карточка Позиция Окончание;Integer  }
    { 50004;  ;Диск. Карт. Позиция Начало;Integer  }
    { 50005;  ;Диск. Карт. Позиция Окончание;Integer }
    { 50006;  ;Менеджер Ресторана Код;Code5       ;TableRelation="_Сотрудник Ресторана";
                                                   OnValidate=BEGIN

                                                                СотрудникРесторана.RESET;
                                                                СотрудникРесторана.SETRANGE(СотрудникРесторана."Но.","Менеджер Ресторана Код");
                                                                IF СотрудникРесторана.FIND('-') THEN
                                                                  "Менеджер Ресторана" := СотрудникРесторана.Фамилия + ' ' + СотрудникРесторана.Инициалы;
                                                              END;
                                                               }
    { 50007;  ;Тип Опред. Проек. Продажи Блюд;Option;
                                                   OptionString=По Проекту Зала,По Проекту Блюд }
    { 50018;  ;Билеты Оплаты Серия Номеров;Code20 ;TableRelation="No. Series" }
    { 50019;  ;Касса Консьержа     ;Code10        ;TableRelation="Bank Account".No. }
    { 50024;  ;Счет Но. Безнал.    ;Code10        ;TableRelation="No. Series" }
    { 50025;  ;Учт. Счет Но. Безнал.;Code10       ;TableRelation="No. Series" }
    { 50026;  ;Блюда Только Из Меню;Boolean        }
    { 50027;  ;Классификатор Только Из Меню;Boolean }
    { 50029;  ;Откр. Заказы Закрытие Смены;Boolean }
    { 50030;  ;Откр. Смены Закрытие Z-смены;Boolean }
    { 50031;  ;Откр. Z-смены Закрытие Зала;Boolean }
    { 50032;  ;Откр. Залы Закрытие Предприяти;Boolean }
    { 50033;  ;Название Холдинга   ;Text60         }
    { 50034;  ;Координаты Рабочей обл X;Integer    }
    { 50035;  ;Координаты Рабочей обл Y;Integer    }
    { 50036;  ;Размер рабочей обл X;Integer        }
    { 50037;  ;Размер рабочей обл Y;Integer        }
    { 50038;  ;Def PayMaster Казино;Code10         }
    { 50039;  ;Def PayMaster G     ;Code10         }
    { 50040;  ;Границы кода авторизации;Text10     }
    { 50041;  ;Фильтр по Пеймастерам Сервис Б;Text250 }
    { 50042;  ;Время сдвига отчетности;Time       ;CaptionML=RUS=Время Снятия Z }
    { 50043;  ;Фильтр по Пеймастерам в отч.;Text250 }
    { 50044;  ;Shortcut Dimension 3 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=Ярлык Код Объекта] }
    { 50045;  ;Shortcut Dimension 8 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=Ярлык Конс Ед] }
    { 50046;  ;Dim8                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 8 Code));
                                                   CaptionML=RUS=Консал. Ед. }
    { 50047;  ;Shortcut Dimension 4 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=Ярлык ЕКТУ] }
    { 50048;  ;Dim4                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ;
                                                   Description=yuri 210613 }
    { 50049;  ;Dim4Compl           ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ COMPL;
                                                   Description=yuri 210613 }
    { 50050;  ;Dim4EPR             ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ EPR;
                                                   Description=yuri 130314 }
    { 50051;  ;Dim4Breakfast       ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ Завтрак;
                                                   Description=yuri 010714 }
    { 50052;  ;Man.Class.Openfood  ;Code100       ;TableRelation="Классификация Группа".Код WHERE (Принадлежит Упр=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Классификатор Открытая Цена }
    { 50053;  ;Path for Picture    ;Text250       ;CaptionML=RUS=Путь для Картинок;
                                                   Description=yuri 211114 }
    { 50054;  ;Height for Picture  ;Integer       ;CaptionML=RUS=Высота Картинки;
                                                   Description=yuri 211114 }
    { 50055;  ;Width for Picture   ;Integer       ;CaptionML=RUS=Ширина Картинки;
                                                   Description=yuri 211114 }
    { 50056;  ;Temp Picture        ;BLOB          ;CaptionML=RUS=Картинка;
                                                   Description=yuri 211114 }
    { 50057;  ;Night Time From     ;Time          ;CaptionML=RUS=Время Ночь С;
                                                   Description=yuri 101214 }
    { 50058;  ;Night Time To       ;Time          ;CaptionML=RUS=Время Ночь По;
                                                   Description=yuri 101214 }
    { 50059;  ;Salary Unit of Meas.;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=RUS=Зарплата Ед. Измерения;
                                                   Description=yuri 171214 }
    { 50060;  ;Minutes For Hour    ;Integer       ;CaptionML=RUS=Минут для округления до часа }
    { 50061;  ;Element Code        ;Code20        ;TableRelation="Payroll Element";
                                                   ValidateTableRelation=No;
                                                   CaptionML=[ENU=Element Code;
                                                              RUS=Код элемента зарплаты];
                                                   Description=yuri 211214 }
    { 50062;  ;Menu Happy Hours    ;Code20        ;TableRelation="Учт. Меню Заголовок";
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Фильтр Меню Happy Hours;
                                                   Description=yuri 100415 }
    { 50063;  ;Mng. Class. Food    ;Code100       ;TableRelation="Классификация Группа".Код WHERE (Принадлежит Упр=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Менеджер Класс. Еда;
                                                   Description=yuri 100415 }
    { 50064;  ;Mng. Class. Bev     ;Code100       ;TableRelation="Классификация Группа".Код WHERE (Принадлежит Упр=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Менеджер Класс. Без Алк.;
                                                   Description=yuri 100415 }
    { 50065;  ;Mng. Class. Alko Bev;Code100       ;TableRelation="Классификация Группа".Код WHERE (Принадлежит Упр=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Менеджер Класс. Алк.;
                                                   Description=yuri 100415 }
    { 50066;  ;Dim4CB              ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ C&&B;
                                                   Description=yuri 270515 }
    { 50067;  ;Dim4FBHB            ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=ЕКТУ FB-HB;
                                                   Description=yuri 130317 }
    { 67000;  ;Active Personal Log ;Boolean       ;CaptionML=RUS=Включить лог действий пользователя;
                                                   Description=#67622 }
    { 69000;  ;Storno Resource No. ;Code20        ;TableRelation=Resource;
                                                   CaptionML=[ENU=Storno Resource No.;
                                                              RUS=Номер ресурса сторно];
                                                   Description=79348 }
    { 69001;  ;Storno Restore Role ;Code20        ;TableRelation="User Role"."Role ID";
                                                   CaptionML=[ENU=Storno Restore Role;
                                                              RUS=Роль сторнирования в ресторане];
                                                   Description=79348 }
    { 69002;  ;Set Off Series No.  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=[ENU=Set Off Series No.;
                                                              RUS=Взаимозачеты Серия Номеров] }
    { 21001510;;Dim3               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(КОД ОБЪЕКТА),
                                                                                               Dim 3=CONST(Yes)) }
    { 21001511;;Dim3Compl          ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(КОД ОБЪЕКТА)) }
    { 21001512;;Dim3BN             ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(КОД ОБЪЕКТА));
                                                   CaptionML=RUS=Код Объекта Бал Невест }
    { 21007419;;Dimension For Pay In FJ;Code20    ;TableRelation=Dimension.Code;
                                                   CaptionML=[ENU=Dimension For Pay In FJ;
                                                              RUS=Код Измерения Для Фин. Жур.] }
    { 21007420;;Dimension Value For Bonus;Code20  ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension For Pay In FJ));
                                                   CaptionML=[ENU=Dimension Value For Bonus;
                                                              RUS=Значение Измерения Для Бонусов] }
    { 21007421;;Dimension Value For Money;Code20  ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension For Pay In FJ));
                                                   CaptionML=[ENU=Dimension Value For Money;
                                                              RUS=Значение Измерения Для Денег] }
    { 21007422;;Billiard External System;Integer  ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=Бильярд Внешняя Система }
    { 21007423;;Bowling External System;Integer   ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=Боулинг Внешняя Система }
    { 21007424;;Wi-Fi External System;Integer     ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=Wi-Fi Внешняя Система }
    { 21007426;;Edit Class.        ;Boolean       ;CaptionML=RUS=Редактировать Классификатор;
                                                   Description=yuri 271014 }
    { 21007427;;Deposit Emp No.    ;Code20        ;TableRelation="_Сотрудник Ресторана";
                                                   CaptionML=RUS=Сотрудник Закрытие Депозит;
                                                   Description=yuri 230315 }
    { 21007428;;CB Emp No.         ;Code20        ;TableRelation="_Сотрудник Ресторана";
                                                   CaptionML=RUS=Сотрудник Закрытие Банкет;
                                                   Description=yuri 080615 }
    { 21007429;;Man.Class.Hookah   ;Code50        ;TableRelation="Классификация Группа".Код WHERE (Принадлежит Упр=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=Мен. Класс. Кальян;
                                                   Description=yuri 290615 }
    { 21007430;;Show Emp No.       ;Code20        ;TableRelation="_Сотрудник Ресторана";
                                                   CaptionML=RUS=Сотрудник Закрытие Шоу;
                                                   Description=yuri 150119 }
  }
  KEYS
  {
    {    ;Ключ                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      СотрудникРесторана@1000000000 : Record 21001403;
      RestFunc@1101967000 : Codeunit 21001403;

    BEGIN
    {
      yuri > 28.05.13 + Dim8 Консал. Ед.
      csa 290914 (67622) - логирование действия пользователя
      apik 291014 (79348) добавлено поле Storno Resource No.
    }
    END.
  }
}

