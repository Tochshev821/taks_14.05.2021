table 21001406 "Personal Log Entry"
{
    // version KRF,#67622

    Caption = 'Персонал Монитор';
    DataPerCompany = false;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Операция Но.';
        }
        field(2;"Action";Text[30])
        {
            Caption = 'Действие';
        }
        field(3;"User ID";Code[20])
        {
            Caption = 'Пользователь Код';
        }
        field(4;"Computer Name";Text[30])
        {
            Caption = 'Имя Компьютера';
        }
        field(5;"Create Date";Date)
        {
            Caption = 'Дата';
        }
        field(50000;"Create Time";Time)
        {
            Caption = 'Время';
        }
        field(50001;Params1;Text[250])
        {
            Caption = 'Параметр 1';
        }
        field(50002;Params2;Text[250])
        {
            Caption = 'Параметр 2';
        }
        field(50003;Hall;Code[20])
        {
            Caption = 'Зал';
        }
        field(50004;"Order";Code[20])
        {
            Caption = 'Заказ Но.';
            TableRelation = "_Учт. Заказ Ресторана Заголово";
        }
        field(50005;HallUser;Code[20])
        {
            Caption = 'Сотрудник Ресторана';
            TableRelation = "_Сотрудник Ресторана"."Но.";
        }
        field(50006;DigitalSign;Text[30])
        {
            Caption = 'Цифровая подпись';
            TableRelation = "Ресторан Цифровая Подпись";
        }
        field(50007;BonusCard;Text[30])
        {
            Caption = 'Бонусная карта';
        }
        field(50008;"DigitalSign Name";Text[64])
        {
            CalcFormula = Lookup("Ресторан Цифровая Подпись"."ФИО" WHERE ("Код"=FIELD(DigitalSign)));
            Caption = 'Цифровая Подпись ФИО';
            FieldClass = FlowField;
        }
        field(50009;"HallUser Name";Text[30])
        {
            CalcFormula = Lookup("_Сотрудник Ресторана"."Фамилия" WHERE ("Но."=FIELD(HallUser)));
            Caption = 'Сотрудник ФИО';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            MaintainSIFTIndex = false;
        }
        key(Key2;"Action","User ID","Create Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LoqEntry: Record "Personal Log Entry";
    begin
        if not LoqEntry.FindLast then
          Clear(LoqEntry);

        "Entry No." := LoqEntry."Entry No." + 1;
    end;

    procedure AddLog(CommandLine: Text[1024])
    var
        RestorantSetup: Record "Менеджер Ресторана Настройка";
        LoqEntry: Record "Personal Log Entry";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        PosNo: Integer;
        Command: Text[30];
        Value: Text[250];
        CurrFiledNo: Integer;
    begin
        RestorantSetup.Get;
        if not RestorantSetup."Active Personal Log" then
          exit;

        //IF LoqEntry.FINDLAST THEN;
        //"Entry No." := LoqEntry."Entry No." + 1;
        "User ID" := UserId;
        "Computer Name" := Environ('COMPUTERNAME');
        "Create Date" := Today;
        "Create Time" := Time;

        Clear(RecRef);
        RecRef.Open(DATABASE::"Personal Log Entry");
        RecRef.GetTable(Rec);

        while CommandLine <> '' do begin
          PosNo := StrPos(CommandLine, '=');
          Command := CopyStr(CommandLine,1,PosNo-1);
          CommandLine := CopyStr(CommandLine,PosNo+1);
          PosNo := StrPos(CommandLine, '&');
          if PosNo <> 0 then begin
            Value := CopyStr(CommandLine,1,PosNo-1);
            CommandLine := CopyStr(CommandLine,PosNo+1);
          end else begin
            Value := CommandLine;
            CommandLine := '';
          end;

          CurrFiledNo := GetFieldNo(DATABASE::"Personal Log Entry", Command);
          if CurrFiledNo <> 0 then begin
            FieldRef := RecRef.Field(CurrFiledNo);
            FieldRef.Value := Value;
          end else begin
            if StrLen(Params1 + ' ' + Command + '=' + Value) < MaxStrLen(Params1) then
              Params1 += ' ' + Command + '=' + Value
            else if StrLen(Params2 + ' ' + Command + '=' + Value) < MaxStrLen(Params2) then
              Params2 += ' ' + Command + '=' + Value
          end;
        end;

        RecRef.Insert(true);
        RecRef.SetTable(Rec);
        RecRef.Close;
    end;

    procedure GetFieldNo(TableNo: Integer;FieldName: Text[50]): Integer
    var
        "Field": Record "Field";
    begin
        Clear(Field);
        Field.SetCurrentKey(TableNo,"No.");
        Field.SetRange(TableNo, TableNo);
        Field.SetRange(FieldName, FieldName);
        if not Field.FindFirst then
          exit(0);

         exit(Field."No.");
    end;
}

