OBJECT Table 21001406 Personal Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=09.02.21;
    Time=15:03:11;
    Modified=Yes;
    Version List=KRF,BC+;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    OnInsert=VAR
               LoqEntry@1000000000 : Record 21001406;
             BEGIN
               IF NOT LoqEntry.FINDLAST THEN
                 CLEAR(LoqEntry);

               "Entry No." := LoqEntry."Entry No." + 1;
             END;

    CaptionML=RUS=���ᮭ�� ������;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=RUS=������ ��. }
    { 2   ;   ;Action              ;Text30        ;CaptionML=RUS=����⢨� }
    { 3   ;   ;User ID             ;Code20        ;CaptionML=RUS=���짮��⥫� ��� }
    { 4   ;   ;Computer Name       ;Text30        ;CaptionML=RUS=��� �������� }
    { 5   ;   ;Create Date         ;Date          ;CaptionML=RUS=��� }
    { 50000;  ;Create Time         ;Time          ;CaptionML=RUS=�६� }
    { 50001;  ;Params1             ;Text250       ;CaptionML=RUS=��ࠬ��� 1 }
    { 50002;  ;Params2             ;Text250       ;CaptionML=RUS=��ࠬ��� 2 }
    { 50003;  ;Hall                ;Code20        ;CaptionML=RUS=��� }
    { 50004;  ;Order               ;Code20        ;TableRelation="_���. ����� ����࠭� ��������";
                                                   CaptionML=RUS=����� ��. }
    { 50005;  ;HallUser            ;Code20        ;TableRelation="_����㤭�� ����࠭�".��.;
                                                   CaptionML=RUS=����㤭�� ����࠭� }
    { 50006;  ;DigitalSign         ;Text30        ;TableRelation="����࠭ ���஢�� �������";
                                                   CaptionML=RUS=���஢�� ������� }
    { 50007;  ;BonusCard           ;Text30        ;CaptionML=RUS=����᭠� ���� }
    { 50008;  ;DigitalSign Name    ;Text64        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("����࠭ ���஢�� �������".��� WHERE (���=FIELD(DigitalSign)));
                                                   CaptionML=RUS=���஢�� ������� ��� }
    { 50009;  ;HallUser Name       ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_����㤭�� ����࠭�".������� WHERE (��.=FIELD(HallUser)));
                                                   CaptionML=RUS=����㤭�� ��� }
  }
  KEYS
  {
    {    ;Entry No.                               ;MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Action,User ID,Create Date               }
    {    ;HallUser                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AppMgt@1000000000 : Codeunit 1;

    PROCEDURE AddLog@1000000000(CommandLine@1000000000 : Text[1024]);
    VAR
      RestorantSetup@1000000008 : Record 21001400;
      LoqEntry@1000000002 : Record 21001406;
      RecRef@1000000001 : RecordRef;
      FieldRef@1000000007 : FieldRef;
      PosNo@1000000003 : Integer;
      Command@1000000004 : Text[30];
      Value@1000000005 : Text[250];
      CurrFiledNo@1000000006 : Integer;
    BEGIN
      RestorantSetup.GET;
      IF NOT RestorantSetup."Active Personal Log" THEN
        EXIT;

      //IF LoqEntry.FINDLAST THEN;
      //"Entry No." := LoqEntry."Entry No." + 1;
      "User ID" := USERID;
      "Computer Name" := AppMgt.GetComputerName;
      "Create Date" := TODAY;
      "Create Time" := TIME;

      CLEAR(RecRef);
      RecRef.OPEN(DATABASE::"Personal Log Entry");
      RecRef.GETTABLE(Rec);

      WHILE CommandLine <> '' DO BEGIN
        PosNo := STRPOS(CommandLine, '=');
        Command := COPYSTR(CommandLine,1,PosNo-1);
        CommandLine := COPYSTR(CommandLine,PosNo+1);
        PosNo := STRPOS(CommandLine, '&');
        IF PosNo <> 0 THEN BEGIN
          Value := COPYSTR(CommandLine,1,PosNo-1);
          CommandLine := COPYSTR(CommandLine,PosNo+1);
        END ELSE BEGIN
          Value := CommandLine;
          CommandLine := '';
        END;

        CurrFiledNo := GetFieldNo(DATABASE::"Personal Log Entry", Command);
        IF CurrFiledNo <> 0 THEN BEGIN
          FieldRef := RecRef.FIELD(CurrFiledNo);
          FieldRef.VALUE := Value;
        END ELSE BEGIN
          IF STRLEN(Params1 + ' ' + Command + '=' + Value) < MAXSTRLEN(Params1) THEN
            Params1 += ' ' + Command + '=' + Value
          ELSE IF STRLEN(Params2 + ' ' + Command + '=' + Value) < MAXSTRLEN(Params2) THEN
            Params2 += ' ' + Command + '=' + Value
        END;
      END;

      RecRef.INSERT(TRUE);
      RecRef.SETTABLE(Rec);
      RecRef.CLOSE;
    END;

    PROCEDURE GetFieldNo@1000000001(TableNo@1000000001 : Integer;FieldName@1000000002 : Text[50]) : Integer;
    VAR
      Field@1000000000 : Record 2000000041;
    BEGIN
      CLEAR(Field);
      Field.SETCURRENTKEY(TableNo,"No.");
      Field.SETRANGE(TableNo, TableNo);
      Field.SETRANGE(FieldName, FieldName);
      IF NOT Field.FINDFIRST THEN
        EXIT(0);

       EXIT(Field."No.");
    END;

    BEGIN
    END.
  }
}

