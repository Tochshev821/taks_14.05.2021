OBJECT Table 21001403 _Сотрудник Ресторана
{
  OBJECT-PROPERTIES
  {
    Date=01.04.21;
    Time=10:36:17;
    Modified=Yes;
    Version List=KRF,FRS,TZY,BC+;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    DataCaptionFields=Но.,Фамилия,Имя,Отчество;
    OnInsert=BEGIN
               IF "Но." = '' THEN
               BEGIN
                 МенеджерРесторанаНастройка.GET;
                 МенеджерРесторанаНастройка.TESTFIELD("Сотрудник Ресторана Серия Но.");
                 СерииНоУпр.ИницСерии(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.",
                                      xRec."Серия Номеров",0D,"Но.","Серия Номеров");
               END;
             END;

    OnRename=BEGIN
               "Посл. Дата Изменения" := TODAY;
             END;

    LookupFormID=Form21001404;
    DrillDownFormID=Form21001404;
  }
  FIELDS
  {
    { 1   ;   ;Но.                 ;Code20        ;AltSearchField=Имя Поиска;
                                                   OnValidate=BEGIN
                                                                IF "Но." <> xRec."Но." THEN BEGIN
                                                                  МенеджерРесторанаНастройка.GET;
                                                                  СерииНоУпр.ТестРучной(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.");
                                                                  "Серия Номеров" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;Имя                 ;Text30         }
    { 3   ;   ;Отчество            ;Text30         }
    { 4   ;   ;Фамилия             ;Text30         }
    { 5   ;   ;Инициалы            ;Text30         }
    { 6   ;   ;Должность Название  ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job Title".Name WHERE (Code=FIELD(Код Должности)));
                                                   CaptionML=RUS=Название должности }
    { 7   ;   ;Имя Поиска          ;Code30        ;CaptionML=RUS=Имя поиска }
    { 8   ;   ;Сотрудник Но.       ;Code10        ;TableRelation=Employee;
                                                   OnValidate=VAR
                                                                _recELE@1000000000 : Record 17413;
                                                                _recRestSalary@1000000001 : Record 21026280;
                                                              BEGIN
                                                                МенеджерРесторанаНастройка.GET;

                                                                IF Сотрудник.GET("Сотрудник Но.") THEN BEGIN
                                                                  VALIDATE("Имя Поиска", Сотрудник."Search Name");
                                                                  VALIDATE(Имя, Сотрудник."First Name");
                                                                  VALIDATE(Отчество, Сотрудник."Middle Name");
                                                                  VALIDATE(Фамилия, Сотрудник."Last Name");
                                                                  VALIDATE(Инициалы, Сотрудник.Initials);
                                                                  VALIDATE("Код Должности", Сотрудник."Job Title Code");
                                                                  VALIDATE("Код Подразделения",Сотрудник."Org. Unit Code");
                                                                  VALIDATE(Dismissal,Сотрудник.Status = Сотрудник.Status :: Terminated);

                                                                  _recELE.RESET;
                                                                  _recELE.SETRANGE("Employee No.","Сотрудник Но.");
                                                                  _recELE.SETFILTER("Element Code",МенеджерРесторанаНастройка."Element Code");
                                                                  IF _recELE.FINDSET THEN
                                                                  REPEAT
                                                                    _recRestSalary.INIT;
                                                                    _recRestSalary."Но." := "Но.";
                                                                    _recRestSalary.Date := _recELE."Action Starting Date";
                                                                    _recRestSalary."Salary Unit of Meas." := МенеджерРесторанаНастройка."Salary Unit of Meas.";
                                                                    _recRestSalary."Salary per Unit" := _recELE.Amount;
                                                                    _recRestSalary."Element Code" := _recELE."Element Code";
                                                                    IF _recRestSalary.INSERT THEN;
                                                                  UNTIL _recELE.NEXT = 0;
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;Серия Номеров       ;Code10        ;CaptionML=RUS=Серия номеров }
    { 10  ;   ;Посл. Дата Изменения;Date          ;CaptionML=RUS=Посл. дата изменения }
    { 11  ;   ;Код Компьютера      ;Code20        ;CaptionML=RUS=Код компьютера }
    { 12  ;   ;Комментарий         ;Boolean       ;FieldClass=Normal }
    { 13  ;   ;Код Должности       ;Code10        ;TableRelation="Job Title";
                                                   OnValidate=VAR
                                                                _recJob@1000000000 : Record 12423;
                                                              BEGIN
                                                                IF _recJob.GET("Код Должности") THEN BEGIN
                                                                  //IF (_recJob.Name = 'Помощник бармена') OR (_recJob.Name = 'Помощник официанта') THEN
                                                                  //  "Position Group" := 'BBOY'
                                                                  IF STRPOS(UPPERCASE(_recJob.Name),'БАРМЕН') <> 0 THEN
                                                                    "Position Group" := 'BAR'
                                                                  ELSE IF STRPOS(UPPERCASE(_recJob.Name),'ПОВАР') <> 0 THEN
                                                                    "Position Group" := 'KTCH'
                                                                  ELSE
                                                                    "Position Group" := 'WTR';
                                                                END;
                                                              END;

                                                   CaptionML=RUS=Код должности }
    { 14  ;   ;Код Подразделения   ;Code10        ;TableRelation="Organizational Unit";
                                                   CaptionML=RUS=Код подразделения }
    { 15  ;   ;Подразделение Название;Text250     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Organizational Unit".Name WHERE (Code=FIELD(Код Подразделения))) }
    { 16  ;   ;Идентификационный Но.;Integer       }
    { 50001;  ;Секретный Ключ      ;Code8         ;OnValidate=BEGIN
                                                                IF "Секретный Ключ" <> '' THEN BEGIN
                                                                  em.RESET;
                                                                  em.SETRANGE("Секретный Ключ",Rec."Секретный Ключ");
                                                                  IF em.FIND('-') AND (em."Но." <> "Но.") THEN
                                                                    ERROR('Такой Секретный Ключ уже существует!');

                                                                {-apik 220420
                                                                  ds.RESET;
                                                                  ds.SETRANGE(ds.Код,"Секретный Ключ");
                                                                  IF ds.FIND('-') THEN ERROR('Такой Секретный Ключ уже существует в ЦП!');
                                                                -apik}
                                                                END;
                                                              END;

                                                   CaptionML=RUS=Код авторизации }
    { 50010;  ;Режим Отладки       ;Boolean       ;InitValue=No }
    { 50011;  ;Режим Всех Смен     ;Boolean        }
    { 50012;  ;Менеджер Портье     ;Boolean       ;CaptionML=RUS=Менеджер портье }
    { 50013;  ;СотрудникПортье     ;Text30        ;TableRelation="User Setup"."User ID";
                                                   CaptionML=RUS=Автологин }
    { 50014;  ;t1                  ;Decimal        }
    { 50015;  ;t2                  ;Decimal        }
    { 50016;  ;t3                  ;Decimal        }
    { 50017;  ;t4                  ;Decimal        }
    { 50018;  ;t5                  ;Decimal        }
    { 50019;  ;t6                  ;Decimal        }
    { 50020;  ;t7                  ;Decimal        }
    { 50021;  ;Dismissal           ;Boolean       ;OnValidate=VAR
                                                                _recHallPermit@1000000000 : Record 21001427;
                                                              BEGIN
                                                                //apik 090221 > для исключения одинаковых моб. логинов
                                                                IF (NOT Dismissal) AND ("Mobile Login" <> '') THEN
                                                                  CheckLoginDuplicate;
                                                                //apik 090221 < для исключения одинаковых моб. логинов
                                                                _recHallPermit.SETRANGE("Официант Но.","Но.");
                                                                _recHallPermit.MODIFYALL(Блокирован,Dismissal);
                                                              END;

                                                   CaptionML=RUS=Уволен;
                                                   Description=yuri 161214 }
    { 50022;  ;Position Group      ;Code10        ;TableRelation="Y Position Group".No.;
                                                   CaptionML=RUS=Должность группа;
                                                   Description=yuri 161214 }
    { 50023;  ;Position Group Desr.;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Y Position Group".Description WHERE (No.=FIELD(Position Group)));
                                                   CaptionML=RUS=Долж. группа описанеи;
                                                   Description=yuri 161214 }
    { 50024;  ;Y-Shifts            ;Integer       ;FieldClass=FlowFilter;
                                                   CaptionML=RUS=Y-Смена;
                                                   Description=yuri 211214 }
    { 50025;  ;Exists In Y-Shift   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Y-Shifts Commands" WHERE (No.=FIELD(Y-Shifts),
                                                                                                Restaurant Emp. No.=FIELD(Но.),
                                                                                                Open=CONST(Yes)));
                                                   CaptionML=RUS=Есть в Y-Смене }
    { 50026;  ;Agent No.           ;Code20        ;TableRelation=Customer.No. WHERE (Restorant Agent=CONST(Yes));
                                                   CaptionML=RUS=Агент Но. }
    { 50027;  ;Agent Name          ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Agent No.)));
                                                   CaptionML=RUS=Имя агента }
    { 50028;  ;Event Manager       ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=RUS=Менеджер мероприятия;
                                                   Description=yuri 270716 }
    { 50029;  ;Event Manager Name  ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Event Manager)));
                                                   CaptionML=RUS=Имя менеджера мепрориятия;
                                                   Description=yuri 270716 }
    { 50030;  ;Virtual             ;Boolean       ;CaptionML=RUS=Виртуальный }
    { 50031;  ;Tax Code            ;Code10        ;TableRelation="Y Tax Code";
                                                   CaptionML=RUS=Ставка налога;
                                                   Description=yuri 211217 }
    { 50032;  ;Tax Rate, %         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Y Tax Code"."Rate, %" WHERE (Tax Code=FIELD(Tax Code)));
                                                   CaptionML=RUS=Ставка, %;
                                                   Description=yuri 211217 }
    { 50033;  ;Emp. Status         ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Employee.Status WHERE (No.=FIELD(Сотрудник Но.)));
                                                   CaptionML=[ENU=Status;
                                                              RUS=Статус];
                                                   OptionCaptionML=[ENU=Active,Inactive,Terminated;
                                                                    RUS=Активен,Неактивен,Уволен];
                                                   OptionString=Active,Inactive,Terminated }
    { 50034;  ;Outsource Access Levels Code;Code20;TableRelation="Outsource Access Levels";
                                                   CaptionML=RUS=Код уровня доступа аутсорс;
                                                   Description=Azat 270918 SD212072 }
    { 50035;  ;Is Outsource        ;Boolean       ;CaptionML=RUS=Аутсорс;
                                                   Description=Azat 280918 SD212072 }
    { 69000;  ;Mobile Login        ;Code20        ;OnValidate=BEGIN
                                                                //apik 090221 > для исключения одинаковых моб. логинов
                                                                IF (NOT Dismissal) AND ("Mobile Login" <> '') THEN
                                                                  CheckLoginDuplicate;
                                                                //apik 090221 < для исключения одинаковых моб. логинов
                                                              END;

                                                   CaptionML=[ENU=Mobile Login;
                                                              RUS=Логин в моб. прил.] }
    { 69001;  ;Mobile Password     ;Text30        ;CaptionML=[ENU=Mobile Password;
                                                              RUS=Пароль в моб. прил.] }
    { 69002;  ;Mobile Role         ;Option        ;CaptionML=[ENU=Mobile Role;
                                                              RUS=Роль в моб. приложении];
                                                   OptionCaptionML=[ENU=" ,Cook,Runner,All";
                                                                    RUS=" ,Повар,Официант,Все"];
                                                   OptionString=[ ,Cook,Runner,All] }
    { 69011;  ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[ENU=Date Filter;
                                                              RUS=Фильтр по дате] }
    { 69012;  ;Tip Amount          ;Decimal       ;FieldClass=FlowField;
                                                   InitValue=0;
                                                   CalcFormula=Sum("Tip Ledger Entry"."Tip Amount" WHERE (Employee No.=FIELD(Но.),
                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[ENU=Tip Amount;
                                                              RUS=Сумма чаевых];
                                                   Editable=No }
    { 69013;  ;Tip URL             ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[ENU=Tip URL;
                                                              RUS=URL выдачи чаевых] }
  }
  KEYS
  {
    {    ;Но.                                     ;Clustered=Yes }
    {    ;t1                                       }
    {    ;t2                                       }
    {    ;t3                                       }
    {    ;t4                                       }
    {    ;t5                                       }
    {    ;t6                                       }
    {    ;t7                                       }
    {    ;Position Group,Фамилия                   }
    {    ;Секретный Ключ                           }
    {    ;Фамилия                                  }
    {    ;Mobile Login                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      МенеджерРесторанаНастройка@1000000000 : Record 21001400;
      СотрудникРесторана@1000000001 : Record 21001403;
      Сотрудник@1000000002 : Record 5200;
      Пользователь@1000000003 : Record 2000000002;
      СерииНоУпр@1000000004 : Codeunit 21006008;
      em@1000000005 : Record 21001403;
      ds@1000000006 : Record 21006032;
      TextDupLogin@1000000007 : TextConst 'RUS=Тот же логин имеет другой сотрудник: %1 %2';

    PROCEDURE AssistEdit@2(СтарСотрудникРест@1000000000 : Record 21001403) : Boolean;
    BEGIN
      WITH СотрудникРесторана DO BEGIN
        СотрудникРесторана := Rec;
        МенеджерРесторанаНастройка.GET;
        МенеджерРесторанаНастройка.TESTFIELD("Сотрудник Ресторана Серия Но.");
        IF СерииНоУпр.ВыбратьСерию(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.",
                                   СтарСотрудникРест."Серия Номеров","Серия Номеров") THEN BEGIN
          МенеджерРесторанаНастройка.GET;
          МенеджерРесторанаНастройка.TESTFIELD("Сотрудник Ресторана Серия Но.");
          СерииНоУпр.УстСерию("Но.");
          Rec := СотрудникРесторана;
          EXIT(TRUE);
        END;
      END;
    END;

    PROCEDURE GetCashier@1000000000() : Text[40];
    BEGIN
      EXIT(Фамилия + ' ' + Инициалы);
    END;

    PROCEDURE FindUserID@1000000001(_UserID@1000000000 : Code[20]) : Boolean;
    BEGIN
      IF _UserID <> '' THEN BEGIN
        RESET;
        SETRANGE(СотрудникПортье, _UserID);
        EXIT(FINDFIRST);
      END;
    END;

    PROCEDURE FindMobileUser@1000000002(MobLogin@1000000000 : Code[20]) : Boolean;
    VAR
      EmpRest@1000000001 : Record 21001403;
    BEGIN
      IF MobLogin <> '' THEN BEGIN
        EmpRest.SETCURRENTKEY("Mobile Login");
        EmpRest.SETRANGE("Mobile Login", MobLogin);
        EmpRest.SETRANGE(Dismissal, FALSE);
        IF EmpRest.FINDFIRST THEN BEGIN
          Rec := EmpRest;
          EXIT(TRUE);
        END;
      END;
    END;

    PROCEDURE CheckLoginDuplicate@1000000003();
    VAR
      EmpRest@1000000000 : Record 21001403;
    BEGIN
      IF "Mobile Login" <> '' THEN BEGIN
        EmpRest.SETCURRENTKEY("Mobile Login");
        EmpRest.SETRANGE("Mobile Login", "Mobile Login");
        EmpRest.SETRANGE(Dismissal, FALSE);
        EmpRest.SETFILTER("Но.", '<>%1', "Но.");
        IF EmpRest.FINDFIRST THEN
          ERROR(TextDupLogin, EmpRest."Но.", EmpRest."Имя Поиска");
      END;
    END;

    BEGIN
    END.
  }
}

