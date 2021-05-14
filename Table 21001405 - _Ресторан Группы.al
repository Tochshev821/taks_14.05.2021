table 21001405 "_Ресторан Группы"
{
    // version KRF CHECK010420

    DataPerCompany = false;
    DrillDownPageID = "_Ресторан Группы Список";
    LookupPageID = "_Ресторан Группы Список";

    fields
    {
        field(1;"Код";Code[10])
        {
        }
        field(2;"Название";Text[30])
        {
        }
        field(3;"Название 2";Text[30])
        {
        }
        field(50001;"Максимальная Скидка%";Decimal)
        {
        }
        field(50002;"Режим ФФ";Boolean)
        {
            Description = 'в расчете только Экспр. оплата';
        }
    }

    keys
    {
        key(Key1;"Код")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        _recRight: Record "KR Group Rights";
    begin
        _recRight.SetRange("Код Группы", Код);
        _recRight.DeleteAll;
    end;
}

