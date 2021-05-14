table 21001408 "KR Group Rights"
{
    // version KRF

    Caption = 'Группа права доступа ';
    DataPerCompany = false;
    DrillDownPageID = "KR Group Rights List";
    LookupPageID = "KR Group Rights List";

    fields
    {
        field(1;"Код Группы";Code[10])
        {
            TableRelation = "_Ресторан Группы";
        }
        field(2;"Код Действия";Code[10])
        {
            TableRelation = "KR Access Rights";

            trigger OnValidate()
            begin

                РесторанДействия.Reset;
                РесторанДействия.SetRange(Код,"Код Действия");
                if РесторанДействия.Find('-') then
                begin
                  Название := РесторанДействия.Название;
                  "Название 2" := РесторанДействия."Название 2";

                end;
            end;
        }
        field(3;"Название";Text[30])
        {
        }
        field(4;"Название 2";Text[30])
        {
        }
        field(5;"Код Группировки";Code[10])
        {
        }
        field(50001;"Право на Действие";Boolean)
        {
            Caption = 'Разрешено';
        }
        field(50002;"Право на Подпись";Boolean)
        {
            Caption = 'Не требовать подтверждение';
        }
        field(50003;"Group Name";Text[30])
        {
            CalcFormula = Lookup("_Ресторан Группы"."Название" WHERE ("Код"=FIELD("Код Группы")));
            Caption = 'Название Группы';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Код Группы","Код Действия")
        {
        }
        key(Key2;"Код Группировки","Код Действия")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "РесторанДействия": Record "KR Access Rights";
}

