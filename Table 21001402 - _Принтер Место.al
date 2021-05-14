table 21001402 "_Принтер Место"
{
    // version KRF,PPC,mod

    DataPerCompany = false;
    LookupPageID = "_Принтер Место_щдв";

    fields
    {
        field(1;"Код Места";Code[20])
        {
        }
        field(50001;"Код Зала";Code[10])
        {
            TableRelation = "KR Hall";
        }
        field(50002;"Код Компьютера";Code[20])
        {
        }
        field(50003;LDN;Text[30])
        {
        }
        field(50004;"Выключен";Boolean)
        {
        }
        field(50006;"Наличие Слипа";Boolean)
        {
        }
        field(50007;"Кодовая Страница";Integer)
        {
        }
        field(50008;"IP Сервера Печати";Text[30])
        {
        }
        field(50009;"Номер Сервера Печати";Integer)
        {
        }
        field(50010;"Длина Строки";Integer)
        {
        }
        field(50011;"Длина Строки Слипа";Integer)
        {
        }
        field(50012;"Колво Строк Слипа";Integer)
        {
        }
        field(50013;"Отступ Сверху";Integer)
        {
        }
        field(50014;"Отступ Снизу";Integer)
        {
        }
        field(50015;"Slip STAR mode";Boolean)
        {
        }
        field(50016;"Описание Места";Text[60])
        {
        }
        field(50017;"Номер";Integer)
        {
        }
        field(50018;"Номер Заместителя";Integer)
        {
        }
        field(50019;"Код места для PPC";Code[20])
        {
            Description = 'PocketPC выделенный принтер';
            TableRelation = "_Принтер Место"."Код Места";
        }
        field(50020;"КодМестаАльт";Code[100])
        {
            Description = 'PocketPC Альтерн. принтер';
        }
        field(50021;"Печать предчека на ТП";Boolean)
        {
        }
        field(50022;"Звонок Есть";Boolean)
        {
        }
        field(50023;"Количество Слипов";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Код Места","Код Зала","Код Компьютера",LDN)
        {
        }
    }

    fieldgroups
    {
    }
}

