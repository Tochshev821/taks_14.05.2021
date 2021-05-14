OBJECT Table 21001403 _����㤭�� ����࠭�
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
    DataCaptionFields=��.,�������,���,����⢮;
    OnInsert=BEGIN
               IF "��." = '' THEN
               BEGIN
                 ������������࠭�����ன��.GET;
                 ������������࠭�����ன��.TESTFIELD("����㤭�� ����࠭� ���� ��.");
                 ��ਨ�����.���摥ਨ(������������࠭�����ன��."����㤭�� ����࠭� ���� ��.",
                                      xRec."���� ����஢",0D,"��.","���� ����஢");
               END;
             END;

    OnRename=BEGIN
               "���. ��� ���������" := TODAY;
             END;

    LookupFormID=Form21001404;
    DrillDownFormID=Form21001404;
  }
  FIELDS
  {
    { 1   ;   ;��.                 ;Code20        ;AltSearchField=��� ���᪠;
                                                   OnValidate=BEGIN
                                                                IF "��." <> xRec."��." THEN BEGIN
                                                                  ������������࠭�����ன��.GET;
                                                                  ��ਨ�����.�����筮�(������������࠭�����ன��."����㤭�� ����࠭� ���� ��.");
                                                                  "���� ����஢" := '';
                                                                END;
                                                              END;
                                                               }
    { 2   ;   ;���                 ;Text30         }
    { 3   ;   ;����⢮            ;Text30         }
    { 4   ;   ;�������             ;Text30         }
    { 5   ;   ;���樠��            ;Text30         }
    { 6   ;   ;��������� ��������  ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job Title".Name WHERE (Code=FIELD(��� ��������)));
                                                   CaptionML=RUS=�������� �������� }
    { 7   ;   ;��� ���᪠          ;Code30        ;CaptionML=RUS=��� ���᪠ }
    { 8   ;   ;����㤭�� ��.       ;Code10        ;TableRelation=Employee;
                                                   OnValidate=VAR
                                                                _recELE@1000000000 : Record 17413;
                                                                _recRestSalary@1000000001 : Record 21026280;
                                                              BEGIN
                                                                ������������࠭�����ன��.GET;

                                                                IF ����㤭��.GET("����㤭�� ��.") THEN BEGIN
                                                                  VALIDATE("��� ���᪠", ����㤭��."Search Name");
                                                                  VALIDATE(���, ����㤭��."First Name");
                                                                  VALIDATE(����⢮, ����㤭��."Middle Name");
                                                                  VALIDATE(�������, ����㤭��."Last Name");
                                                                  VALIDATE(���樠��, ����㤭��.Initials);
                                                                  VALIDATE("��� ��������", ����㤭��."Job Title Code");
                                                                  VALIDATE("��� ���ࠧ�������",����㤭��."Org. Unit Code");
                                                                  VALIDATE(Dismissal,����㤭��.Status = ����㤭��.Status :: Terminated);

                                                                  _recELE.RESET;
                                                                  _recELE.SETRANGE("Employee No.","����㤭�� ��.");
                                                                  _recELE.SETFILTER("Element Code",������������࠭�����ன��."Element Code");
                                                                  IF _recELE.FINDSET THEN
                                                                  REPEAT
                                                                    _recRestSalary.INIT;
                                                                    _recRestSalary."��." := "��.";
                                                                    _recRestSalary.Date := _recELE."Action Starting Date";
                                                                    _recRestSalary."Salary Unit of Meas." := ������������࠭�����ன��."Salary Unit of Meas.";
                                                                    _recRestSalary."Salary per Unit" := _recELE.Amount;
                                                                    _recRestSalary."Element Code" := _recELE."Element Code";
                                                                    IF _recRestSalary.INSERT THEN;
                                                                  UNTIL _recELE.NEXT = 0;
                                                                END;
                                                              END;
                                                               }
    { 9   ;   ;���� ����஢       ;Code10        ;CaptionML=RUS=���� ����஢ }
    { 10  ;   ;���. ��� ���������;Date          ;CaptionML=RUS=���. ��� ��������� }
    { 11  ;   ;��� ��������      ;Code20        ;CaptionML=RUS=��� �������� }
    { 12  ;   ;�������਩         ;Boolean       ;FieldClass=Normal }
    { 13  ;   ;��� ��������       ;Code10        ;TableRelation="Job Title";
                                                   OnValidate=VAR
                                                                _recJob@1000000000 : Record 12423;
                                                              BEGIN
                                                                IF _recJob.GET("��� ��������") THEN BEGIN
                                                                  //IF (_recJob.Name = '����魨� ��ଥ��') OR (_recJob.Name = '����魨� ��樠��') THEN
                                                                  //  "Position Group" := 'BBOY'
                                                                  IF STRPOS(UPPERCASE(_recJob.Name),'������') <> 0 THEN
                                                                    "Position Group" := 'BAR'
                                                                  ELSE IF STRPOS(UPPERCASE(_recJob.Name),'�����') <> 0 THEN
                                                                    "Position Group" := 'KTCH'
                                                                  ELSE
                                                                    "Position Group" := 'WTR';
                                                                END;
                                                              END;

                                                   CaptionML=RUS=��� �������� }
    { 14  ;   ;��� ���ࠧ�������   ;Code10        ;TableRelation="Organizational Unit";
                                                   CaptionML=RUS=��� ���ࠧ������� }
    { 15  ;   ;���ࠧ������� ��������;Text250     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Organizational Unit".Name WHERE (Code=FIELD(��� ���ࠧ�������))) }
    { 16  ;   ;�����䨪�樮��� ��.;Integer       }
    { 50001;  ;������ ����      ;Code8         ;OnValidate=BEGIN
                                                                IF "������ ����" <> '' THEN BEGIN
                                                                  em.RESET;
                                                                  em.SETRANGE("������ ����",Rec."������ ����");
                                                                  IF em.FIND('-') AND (em."��." <> "��.") THEN
                                                                    ERROR('����� ������ ���� 㦥 �������!');

                                                                {-apik 220420
                                                                  ds.RESET;
                                                                  ds.SETRANGE(ds.���,"������ ����");
                                                                  IF ds.FIND('-') THEN ERROR('����� ������ ���� 㦥 ������� � ��!');
                                                                -apik}
                                                                END;
                                                              END;

                                                   CaptionML=RUS=��� ���ਧ�樨 }
    { 50010;  ;����� �⫠���       ;Boolean       ;InitValue=No }
    { 50011;  ;����� ��� ����     ;Boolean        }
    { 50012;  ;�������� �����     ;Boolean       ;CaptionML=RUS=�������� ����� }
    { 50013;  ;����㤭�������     ;Text30        ;TableRelation="User Setup"."User ID";
                                                   CaptionML=RUS=��⮫���� }
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
                                                                //apik 090221 > ��� �᪫�祭�� ���������� ���. �������
                                                                IF (NOT Dismissal) AND ("Mobile Login" <> '') THEN
                                                                  CheckLoginDuplicate;
                                                                //apik 090221 < ��� �᪫�祭�� ���������� ���. �������
                                                                _recHallPermit.SETRANGE("��樠�� ��.","��.");
                                                                _recHallPermit.MODIFYALL(�����஢��,Dismissal);
                                                              END;

                                                   CaptionML=RUS=������;
                                                   Description=yuri 161214 }
    { 50022;  ;Position Group      ;Code10        ;TableRelation="Y Position Group".No.;
                                                   CaptionML=RUS=��������� ��㯯�;
                                                   Description=yuri 161214 }
    { 50023;  ;Position Group Desr.;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Y Position Group".Description WHERE (No.=FIELD(Position Group)));
                                                   CaptionML=RUS=����. ��㯯� ���ᠭ��;
                                                   Description=yuri 161214 }
    { 50024;  ;Y-Shifts            ;Integer       ;FieldClass=FlowFilter;
                                                   CaptionML=RUS=Y-�����;
                                                   Description=yuri 211214 }
    { 50025;  ;Exists In Y-Shift   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Y-Shifts Commands" WHERE (No.=FIELD(Y-Shifts),
                                                                                                Restaurant Emp. No.=FIELD(��.),
                                                                                                Open=CONST(Yes)));
                                                   CaptionML=RUS=���� � Y-����� }
    { 50026;  ;Agent No.           ;Code20        ;TableRelation=Customer.No. WHERE (Restorant Agent=CONST(Yes));
                                                   CaptionML=RUS=����� ��. }
    { 50027;  ;Agent Name          ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Agent No.)));
                                                   CaptionML=RUS=��� ����� }
    { 50028;  ;Event Manager       ;Code10        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=RUS=�������� ��ய����;
                                                   Description=yuri 270716 }
    { 50029;  ;Event Manager Name  ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Event Manager)));
                                                   CaptionML=RUS=��� �������� ��������;
                                                   Description=yuri 270716 }
    { 50030;  ;Virtual             ;Boolean       ;CaptionML=RUS=����㠫�� }
    { 50031;  ;Tax Code            ;Code10        ;TableRelation="Y Tax Code";
                                                   CaptionML=RUS=�⠢�� ������;
                                                   Description=yuri 211217 }
    { 50032;  ;Tax Rate, %         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Y Tax Code"."Rate, %" WHERE (Tax Code=FIELD(Tax Code)));
                                                   CaptionML=RUS=�⠢��, %;
                                                   Description=yuri 211217 }
    { 50033;  ;Emp. Status         ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Employee.Status WHERE (No.=FIELD(����㤭�� ��.)));
                                                   CaptionML=[ENU=Status;
                                                              RUS=�����];
                                                   OptionCaptionML=[ENU=Active,Inactive,Terminated;
                                                                    RUS=��⨢��,����⨢��,������];
                                                   OptionString=Active,Inactive,Terminated }
    { 50034;  ;Outsource Access Levels Code;Code20;TableRelation="Outsource Access Levels";
                                                   CaptionML=RUS=��� �஢�� ����㯠 ������;
                                                   Description=Azat 270918 SD212072 }
    { 50035;  ;Is Outsource        ;Boolean       ;CaptionML=RUS=������;
                                                   Description=Azat 280918 SD212072 }
    { 69000;  ;Mobile Login        ;Code20        ;OnValidate=BEGIN
                                                                //apik 090221 > ��� �᪫�祭�� ���������� ���. �������
                                                                IF (NOT Dismissal) AND ("Mobile Login" <> '') THEN
                                                                  CheckLoginDuplicate;
                                                                //apik 090221 < ��� �᪫�祭�� ���������� ���. �������
                                                              END;

                                                   CaptionML=[ENU=Mobile Login;
                                                              RUS=����� � ���. �ਫ.] }
    { 69001;  ;Mobile Password     ;Text30        ;CaptionML=[ENU=Mobile Password;
                                                              RUS=��஫� � ���. �ਫ.] }
    { 69002;  ;Mobile Role         ;Option        ;CaptionML=[ENU=Mobile Role;
                                                              RUS=���� � ���. �ਫ������];
                                                   OptionCaptionML=[ENU=" ,Cook,Runner,All";
                                                                    RUS=" ,�����,��樠��,��"];
                                                   OptionString=[ ,Cook,Runner,All] }
    { 69011;  ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[ENU=Date Filter;
                                                              RUS=������ �� ���] }
    { 69012;  ;Tip Amount          ;Decimal       ;FieldClass=FlowField;
                                                   InitValue=0;
                                                   CalcFormula=Sum("Tip Ledger Entry"."Tip Amount" WHERE (Employee No.=FIELD(��.),
                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[ENU=Tip Amount;
                                                              RUS=�㬬� 砥���];
                                                   Editable=No }
    { 69013;  ;Tip URL             ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[ENU=Tip URL;
                                                              RUS=URL �뤠� 砥���] }
  }
  KEYS
  {
    {    ;��.                                     ;Clustered=Yes }
    {    ;t1                                       }
    {    ;t2                                       }
    {    ;t3                                       }
    {    ;t4                                       }
    {    ;t5                                       }
    {    ;t6                                       }
    {    ;t7                                       }
    {    ;Position Group,�������                   }
    {    ;������ ����                           }
    {    ;�������                                  }
    {    ;Mobile Login                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ������������࠭�����ன��@1000000000 : Record 21001400;
      ����㤭������࠭�@1000000001 : Record 21001403;
      ����㤭��@1000000002 : Record 5200;
      ���짮��⥫�@1000000003 : Record 2000000002;
      ��ਨ�����@1000000004 : Codeunit 21006008;
      em@1000000005 : Record 21001403;
      ds@1000000006 : Record 21006032;
      TextDupLogin@1000000007 : TextConst 'RUS=��� �� ����� ����� ��㣮� ���㤭��: %1 %2';

    PROCEDURE AssistEdit@2(�������㤭������@1000000000 : Record 21001403) : Boolean;
    BEGIN
      WITH ����㤭������࠭� DO BEGIN
        ����㤭������࠭� := Rec;
        ������������࠭�����ன��.GET;
        ������������࠭�����ன��.TESTFIELD("����㤭�� ����࠭� ���� ��.");
        IF ��ਨ�����.����쑥��(������������࠭�����ன��."����㤭�� ����࠭� ���� ��.",
                                   �������㤭������."���� ����஢","���� ����஢") THEN BEGIN
          ������������࠭�����ன��.GET;
          ������������࠭�����ன��.TESTFIELD("����㤭�� ����࠭� ���� ��.");
          ��ਨ�����.��⑥��("��.");
          Rec := ����㤭������࠭�;
          EXIT(TRUE);
        END;
      END;
    END;

    PROCEDURE GetCashier@1000000000() : Text[40];
    BEGIN
      EXIT(������� + ' ' + ���樠��);
    END;

    PROCEDURE FindUserID@1000000001(_UserID@1000000000 : Code[20]) : Boolean;
    BEGIN
      IF _UserID <> '' THEN BEGIN
        RESET;
        SETRANGE(����㤭�������, _UserID);
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
        EmpRest.SETFILTER("��.", '<>%1', "��.");
        IF EmpRest.FINDFIRST THEN
          ERROR(TextDupLogin, EmpRest."��.", EmpRest."��� ���᪠");
      END;
    END;

    BEGIN
    END.
  }
}

