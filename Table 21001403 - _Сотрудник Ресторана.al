table 21001403 "_Сотрудник Ресторана"
{
    // version KRF,FRS,TZY CHECK010420

    DataCaptionFields = "Но.","Фамилия","Имя","Отчество";
    DataPerCompany = false;
    DrillDownPageID = "_Сотрудник Ресторана Список";
    LookupPageID = "_Сотрудник Ресторана Список";

    fields
    {
        field(1;"Но.";Code[20])
        {

            trigger OnValidate()
            begin
                if "Но." <> xRec."Но." then begin
                  МенеджерРесторанаНастройка.Get;
                  СерииНоУпр.ТестРучной(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.");
                  "Серия Номеров" := '';
                end;
            end;
        }
        field(2;"Имя";Text[30])
        {
        }
        field(3;"Отчество";Text[30])
        {
        }
        field(4;"Фамилия";Text[30])
        {
        }
        field(5;"Инициалы";Text[30])
        {
        }
        field(6;"Должность Название";Text[250])
        {
            CalcFormula = Lookup("Job Title".Name WHERE (Code=FIELD("Код Должности")));
            Caption = 'Название должности';
            FieldClass = FlowField;
        }
        field(7;"Имя Поиска";Code[30])
        {
            Caption = 'Имя поиска';
        }
        field(8;"Сотрудник Но.";Code[10])
        {
            TableRelation = Employee;

            trigger OnValidate()
            var
                _recELE: Record "Employee Ledger Entry";
                _recRestSalary: Record "Restaurant Salary";
            begin
                МенеджерРесторанаНастройка.Get;

                if Сотрудник.Get("Сотрудник Но.") then begin
                  Validate("Имя Поиска", Сотрудник."Search Name");
                  Validate(Имя, Сотрудник."First Name");
                  Validate(Отчество, Сотрудник."Middle Name");
                  Validate(Фамилия, Сотрудник."Last Name");
                  Validate(Инициалы, Сотрудник.Initials);
                  Validate("Код Должности", Сотрудник."Job Title Code");
                  Validate("Код Подразделения",Сотрудник."Org. Unit Code");
                  Validate(Dismissal,Сотрудник.Status = Сотрудник.Status :: Terminated);

                  _recELE.Reset;
                  _recELE.SetRange("Employee No.","Сотрудник Но.");
                  _recELE.SetFilter("Element Code",МенеджерРесторанаНастройка."Element Code");
                  if _recELE.FindSet then
                  repeat
                    _recRestSalary.Init;
                    _recRestSalary."Но." := "Но.";
                    _recRestSalary.Date := _recELE."Action Starting Date";
                    _recRestSalary."Salary Unit of Meas." := МенеджерРесторанаНастройка."Salary Unit of Meas.";
                    _recRestSalary."Salary per Unit" := _recELE.Amount;
                    _recRestSalary."Element Code" := _recELE."Element Code";
                    if _recRestSalary.Insert then;
                  until _recELE.Next = 0;
                end;
            end;
        }
        field(9;"Серия Номеров";Code[10])
        {
            Caption = 'Серия номеров';
        }
        field(10;"Посл. Дата Изменения";Date)
        {
            Caption = 'Посл. дата изменения';
        }
        field(11;"Код Компьютера";Code[20])
        {
            Caption = 'Код компьютера';
        }
        field(12;"Комментарий";Boolean)
        {
            FieldClass = Normal;
        }
        field(13;"Код Должности";Code[10])
        {
            Caption = 'Код должности';
            TableRelation = "Job Title";

            trigger OnValidate()
            var
                _recJob: Record "Job Title";
            begin
                if _recJob.Get("Код Должности") then begin
                  //IF (_recJob.Name = 'Помощник бармена') OR (_recJob.Name = 'Помощник официанта') THEN
                  //  "Position Group" := 'BBOY'
                  if StrPos(UpperCase(_recJob.Name),'БАРМЕН') <> 0 then
                    "Position Group" := 'BAR'
                  else if StrPos(UpperCase(_recJob.Name),'ПОВАР') <> 0 then
                    "Position Group" := 'KTCH'
                  else
                    "Position Group" := 'WTR';
                end;
            end;
        }
        field(14;"Код Подразделения";Code[10])
        {
            Caption = 'Код подразделения';
            TableRelation = "Organizational Unit";
        }
        field(15;"Подразделение Название";Text[250])
        {
            CalcFormula = Lookup("Organizational Unit".Name WHERE (Code=FIELD("Код Подразделения")));
            FieldClass = FlowField;
        }
        field(16;"Идентификационный Но.";Integer)
        {
        }
        field(50001;"Секретный Ключ";Code[8])
        {
            Caption = 'Код авторизации';

            trigger OnValidate()
            begin
                if "Секретный Ключ" <> '' then begin
                  em.Reset;
                  em.SetRange("Секретный Ключ",Rec."Секретный Ключ");
                  if em.Find('-') then Error('Такой Секретный Ключ уже существует!');

                  ds.Reset;
                  ds.SetRange(ds.Код,"Секретный Ключ");
                  if ds.Find('-') then Error('Такой Секретный Ключ уже существует в ЦП!');
                end;
            end;
        }
        field(50010;"Режим Отладки";Boolean)
        {
            InitValue = false;
        }
        field(50011;"Режим Всех Смен";Boolean)
        {
        }
        field(50012;"Менеджер Портье";Boolean)
        {
            Caption = 'Менеджер портье';
        }
        field(50013;"СотрудникПортье";Text[30])
        {
            Caption = 'Автологин';
            TableRelation = "User Setup"."User ID";
        }
        field(50014;t1;Decimal)
        {
        }
        field(50015;t2;Decimal)
        {
        }
        field(50016;t3;Decimal)
        {
        }
        field(50017;t4;Decimal)
        {
        }
        field(50018;t5;Decimal)
        {
        }
        field(50019;t6;Decimal)
        {
        }
        field(50020;t7;Decimal)
        {
        }
        field(50021;Dismissal;Boolean)
        {
            Caption = 'Уволен';
            Description = 'yuri 161214';

            trigger OnValidate()
            var
                _recHallPermit: Record "_Сотрудник Зал Доступ";
            begin
                _recHallPermit.SetRange("Официант Но.","Но.");
                _recHallPermit.ModifyAll(Блокирован,Dismissal);
            end;
        }
        field(50022;"Position Group";Code[10])
        {
            Caption = 'Должность группа';
            Description = 'yuri 161214';
            TableRelation = "Y Position Group"."No.";
        }
        field(50023;"Position Group Desr.";Text[30])
        {
            CalcFormula = Lookup("Y Position Group".Description WHERE ("No."=FIELD("Position Group")));
            Caption = 'Долж. группа описание';
            Description = 'yuri 161214';
            FieldClass = FlowField;
        }
        field(50024;"Y-Shifts";Integer)
        {
            Caption = 'Y-Смена';
            Description = 'yuri 211214';
            FieldClass = FlowFilter;
        }
        field(50025;"Exists In Y-Shift";Boolean)
        {
            CalcFormula = Exist("Y-Shifts Commands" WHERE ("No."=FIELD("Y-Shifts"),
                                                           "Restaurant Emp. No."=FIELD("Но."),
                                                           Open=CONST(true)));
            Caption = 'Есть в Y-Смене';
            FieldClass = FlowField;
        }
        field(50026;"Agent No.";Code[20])
        {
            Caption = 'Агент Но.';
            TableRelation = Customer."No." WHERE ("Restorant Agent"=CONST(true));
        }
        field(50027;"Agent Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE ("No."=FIELD("Agent No.")));
            Caption = 'Имя агента';
            FieldClass = FlowField;
        }
        field(50028;"Event Manager";Code[10])
        {
            Caption = 'Менеджер мероприятия';
            Description = 'yuri 270716';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50029;"Event Manager Name";Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE (Code=FIELD("Event Manager")));
            Caption = 'Имя менеджера мероприятия';
            Description = 'yuri 270716';
            FieldClass = FlowField;
        }
        field(50030;Virtual;Boolean)
        {
            Caption = 'Виртуальный';
        }
        field(50031;"Tax Code";Code[10])
        {
            Caption = 'Ставка налога';
            Description = 'yuri 211217';
            TableRelation = "Y Tax Code";
        }
        field(50032;"Tax Rate, %";Decimal)
        {
            CalcFormula = Lookup("Y Tax Code"."Rate, %" WHERE ("Tax Code"=FIELD("Tax Code")));
            Caption = 'Ставка, %';
            Description = 'yuri 211217';
            FieldClass = FlowField;
        }
        field(50033;"Emp. Status";Option)
        {
            CalcFormula = Lookup(Employee.Status WHERE ("No."=FIELD("Сотрудник Но.")));
            Caption = 'Status';
            FieldClass = FlowField;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(50034;"Outsource Access Levels Code";Code[20])
        {
            Caption = 'Код уровня доступа аутсорс';
            Description = 'Azat 270918 SD212072';
            TableRelation = "Outsource Access Levels";
        }
        field(50035;"Is Outsource";Boolean)
        {
            Caption = 'Аутсорс';
            Description = 'Azat 280918 SD212072';
        }
    }

    keys
    {
        key(Key1;"Но.")
        {
        }
        key(Key2;t1)
        {
        }
        key(Key3;t2)
        {
        }
        key(Key4;t3)
        {
        }
        key(Key5;t4)
        {
        }
        key(Key6;t5)
        {
        }
        key(Key7;t6)
        {
        }
        key(Key8;t7)
        {
        }
        key(Key9;"Position Group","Фамилия")
        {
        }
        key(Key10;"Секретный Ключ")
        {
        }
        key(Key11;"Фамилия")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Но." = '' then
        begin
          МенеджерРесторанаНастройка.Get;
          МенеджерРесторанаНастройка.TestField("Сотрудник Ресторана Серия Но.");
          СерииНоУпр.ИницСерии(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.",
                               xRec."Серия Номеров",0D,"Но.","Серия Номеров");
        end;
    end;

    trigger OnRename()
    begin
        "Посл. Дата Изменения" := Today;
    end;

    var
        "МенеджерРесторанаНастройка": Record "Менеджер Ресторана Настройка";
        "СотрудникРесторана": Record "_Сотрудник Ресторана";
        "Сотрудник": Record Employee;
        "Пользователь": Record User;
        "СерииНоУпр": Codeunit "Ресторан СерииНоУправление";
        em: Record "_Сотрудник Ресторана";
        ds: Record "Ресторан Цифровая Подпись";

    procedure AssistEdit("СтарСотрудникРест": Record "_Сотрудник Ресторана"): Boolean
    begin
        with СотрудникРесторана do begin
          СотрудникРесторана := Rec;
          МенеджерРесторанаНастройка.Get;
          МенеджерРесторанаНастройка.TestField("Сотрудник Ресторана Серия Но.");
          if СерииНоУпр.ВыбратьСерию(МенеджерРесторанаНастройка."Сотрудник Ресторана Серия Но.",
                                     СтарСотрудникРест."Серия Номеров","Серия Номеров") then begin
            МенеджерРесторанаНастройка.Get;
            МенеджерРесторанаНастройка.TestField("Сотрудник Ресторана Серия Но.");
            СерииНоУпр.УстСерию("Но.");
            Rec := СотрудникРесторана;
            exit(true);
          end;
        end;
    end;

    procedure GetCashier(): Text[40]
    begin
        exit(Фамилия + ' ' + Инициалы);
    end;

    procedure FindUserID(_UserID: Code[20]): Boolean
    begin
        if _UserID <> '' then begin
          Reset;
          SetRange(СотрудникПортье, _UserID);
          exit(FindFirst);
        end;
    end;
}

