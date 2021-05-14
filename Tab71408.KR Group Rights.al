OBJECT Table 21001408 KR Group Rights
{
  OBJECT-PROPERTIES
  {
    Date=13.11.14;
    Time=17:28:31;
    Modified=Yes;
    Version List=KRF,BC+;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=RUS="��㯯� �ࠢ� ����㯠 ";
    LookupFormID=Form21001410;
    DrillDownFormID=Form21001410;
  }
  FIELDS
  {
    { 1   ;   ;��� ��㯯�          ;Code10        ;TableRelation="_����࠭ ��㯯�" }
    { 2   ;   ;��� ����⢨�        ;Code10        ;TableRelation="KR Access Rights";
                                                   OnValidate=BEGIN

                                                                ����࠭����⢨�.RESET;
                                                                ����࠭����⢨�.SETRANGE(���,"��� ����⢨�");
                                                                IF ����࠭����⢨�.FIND('-') THEN
                                                                BEGIN
                                                                  �������� := ����࠭����⢨�.��������;
                                                                  "�������� 2" := ����࠭����⢨�."�������� 2";

                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;��������            ;Text30         }
    { 4   ;   ;�������� 2          ;Text30         }
    { 5   ;   ;��� ��㯯�஢��     ;Code10         }
    { 50001;  ;�ࠢ� �� ����⢨�   ;Boolean       ;CaptionML=RUS=����襭� }
    { 50002;  ;�ࠢ� �� �������    ;Boolean       ;CaptionML=RUS=�� �ॡ����� ���⢥ত���� }
    { 50003;  ;Group Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_����࠭ ��㯯�".�������� WHERE (���=FIELD(��� ��㯯�)));
                                                   CaptionML=RUS=�������� ��㯯� }
  }
  KEYS
  {
    {    ;��� ��㯯�,��� ����⢨�                 ;Clustered=Yes }
    {    ;��� ��㯯�஢��,��� ����⢨�             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ����࠭����⢨�@1000000000 : Record 21001407;

    BEGIN
    END.
  }
}

