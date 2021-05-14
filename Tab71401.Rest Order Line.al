OBJECT Table 21001401 _����� ����࠭� ��ப�
{
  OBJECT-PROPERTIES
  {
    Date=15.03.21;
    Time=11:59:02;
    Modified=Yes;
    Version List=KRF,MBR;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    OnInsert=VAR
               _recLine@1000000000 : Record 21001401;
               _recMenuLine@1000000001 : Record 21006014;
               Item@1000000002 : Record 27;
             BEGIN
               IF "��ப� ��." = 0 THEN BEGIN
                 _recLine.SETRANGE("����� ��.", "����� ��.");
                 IF _recLine.FINDLAST THEN
                   "��ப� ��." := _recLine."��ப� ��." + 10
                 ELSE
                   "��ப� ��." := 10;
               END;

               //yuri 040216 >
               //�뤥�塞 ������ ����
               IF _recMenuLine.GET("���� ��.","��� ��","����� ����樨 � ����","��� ����樨") THEN BEGIN
                 _recMenuLine.CALCFIELDS("Lunch Item");
                 IF _recMenuLine."Lunch Item" THEN BEGIN
                   VALIDATE("Main Line For Lunch", "��ப� ��.");
                   VALIDATE("�ਧ��� ������", "�ਧ��� ������" :: "������ ����");
                 END;
               END;
               //yuri 040216 <
               //apik 151020 (270316) ��ࠬ����
               // PreserveParams - ��� ᮧ����� ������� �ࠧ� � ������묨 ����� ��ࠬ��ࠬ�
               IF NOT PreserveParams THEN
                 IF "��� ����樨" = "��� ����樨"::����� THEN
                   CopyMenuParams;
               //apik 151020 (270316) ��ࠬ����
             END;

    OnModify=BEGIN
               //apik 151020 (270316) ��ࠬ����
               // PreserveParams - ��� ᮧ����� ������� �ࠧ� � ������묨 ����� ��ࠬ��ࠬ�
               IF ("��� ��"<> xRec."��� ��") THEN
                 IF NOT PreserveParams THEN  BEGIN
                   DeleteLineParams;
                   IF "��� ����樨" = "��� ����樨"::����� THEN
                     CopyMenuParams;
                 END;
               //apik 151020 (270316) ��ࠬ����
             END;

    OnDelete=VAR
               _recLine@1000000000 : Record 21001401;
             BEGIN
               IF ("�ਧ��� ������" = "�ਧ��� ������"::"������ ����") AND ("��ப� ��." = "Main Line For Lunch") THEN BEGIN
                 _recLine.SETRANGE("����� ��.", "����� ��.");
                 _recLine.SETRANGE("�ਧ��� ������",_recLine."�ਧ��� ������"::"������ ����");
                 _recLine.SETRANGE("Main Line For Lunch", "��ப� ��.");
                 _recLine.SETFILTER("��ப� ��.", '<>%1',"��ப� ��.");
                 _recLine.SETRANGE("����� ��", _recLine."����� ��" :: ��࠭�);
                 _recLine.DELETEALL;
               END;
               //apik 151020 (270316) ��ࠬ����
                 DeleteLineParams;
               //apik 151020 (270316) ��ࠬ����
             END;

    LookupFormID=Form21001468;
    DrillDownFormID=Form21001468;
  }
  FIELDS
  {
    { 1   ;   ;����� ��.           ;Code20         }
    { 2   ;   ;��� ��           ;Code10        ;TableRelation=IF (��� ����樨=CONST(�����)) Item
                                                                 ELSE IF (��� ����樨=CONST(������)) Resource;
                                                   OnValidate=BEGIN
                                                                CLEAR("�������� ��㯯� �����䨪�樨");
                                                                IF ��.GET("��� ��") THEN BEGIN
                                                                  "����࠭ �� ��." := ��."����࠭ �� ��.";
                                                                  IF �������� = '' THEN
                                                                    �������� := ��.Description;   //�᫨ ���⮥ - ��१����뢠��
                                                                  "��� ������� ����७��" := ��."Base Unit of Measure";
                                                                  "�������� ��㯯� �����䨪�樨" := ��."�������� ��㯯� �����䨪�樨";
                                                                END;

                                                                ���������࠭����������.RESET;
                                                                ���������࠭����������.SETRANGE("����� ��.","����� ��.");
                                                                IF ���������࠭����������.FINDFIRST THEN BEGIN
                                                                  ��⌥���ப�.RESET;
                                                                  ��⌥���ப�.SETRANGE("���㬥�� ��.","���� ��.");
                                                                  ��⌥���ப�.SETRANGE("����� ��.","��� ��");
                                                                  ��⌥���ப�.SETRANGE("��ப� ��.","����� ����樨 � ����");
                                                                  ��⌥���ப�.SETRANGE(�����஢���, FALSE);
                                                                  IF NOT ��⌥���ப�.FINDLAST THEN
                                                                    ��⌥���ப�.SETRANGE("��ப� ��.");
                                                                  IF ��⌥���ப�.FINDLAST THEN BEGIN
                                                                    "���� �������" := ��⌥���ப�."���� �த��� ��";
                                                                    �㬬� := ��⌥���ப�."���� �த��� ��";
                                                                    "��� ������� ����७��" := ��⌥���ப�."��� ������� ����७��";
                                                                    �������� := ��⌥���ப�."�� ��������";
                                                                    //��।� := ��⌥���ப�."Course No.";
                                                                  END;

                                                                  IF "��� ������" = 0D THEN
                                                                    "��� ������" := WORKDATE;
                                                                  IF "�६� ������" = 0T THEN
                                                                    "�६� ������" := TIME;
                                                                  "��� �⤥�� ��" := ���������࠭����������."��� �⤥��";
                                                                  IF (���������࠭����������."��� ��砫� ������" = 0D) THEN BEGIN
                                                                    ���������࠭����������."��� ��砫� ������" := WORKDATE;
                                                                    ���������࠭����������."�६� ��砫� ������" := TIME;
                                                                  END;
                                                                  IF ���������࠭����������."��� ����砭�� ������" <> WORKDATE THEN
                                                                    ���������࠭����������."��� ����砭�� ������" := WORKDATE;
                                                                  ���������࠭����������."�६� ����砭�� ������" := TIME;
                                                                  ���������࠭����������.MODIFY;

                                                                  IF "��� ���� �த���" = '' THEN
                                                                    "��� ���� �த���" := ���������࠭����������."��� ���� �த���";
                                                                  DiscountMgt.FindDisc(CREATEDATETIME("��� ������","�६� ������"),Rec);
                                                                  IF "Discount Code" <> '' THEN
                                                                    IF DiscountCode.GET("Discount Code") THEN
                                                                     IF DiscountCode."Price Change" THEN BEGIN
                                                                      RoundIt := RoundMethod.GET(DiscountCode."Rounding Method");
                                                                      DiscAmount := "���� �������" * "Discount %" / 100;
                                                                      "���� �������" -= DiscAmount;
                                                                      IF RoundIt THEN
                                                                        "���� �������" := RoundMethod.RoundAmount("���� �������");
                                                                      IF "���� �������" < 0 THEN
                                                                        "���� �������" := 0;
                                                                     END;
                                                                  VALIDATE("���� �������");
                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;��������            ;Text30        ;FieldClass=Normal }
    { 4   ;   ;�������� 2          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Item."Description 2" WHERE (No.=FIELD(����� ��.))) }
    { 5   ;   ;������⢮          ;Decimal       ;OnValidate=BEGIN
                                                                ������⢮ := ROUND(������⢮,0.001);
                                                                //apik VALIDATE(�㬬�);
                                                                //apik 200716 (164531) > ᪨���
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < ᪨���
                                                              END;

                                                   DecimalPlaces=0:6 }
    { 6   ;   ;�㬬�               ;Decimal       ;OnValidate=BEGIN
                                                                //�㬬� := ROUND("���� �������" * ������⢮,0.01);
                                                                //ClubBonusPriceSumm := ROUND(������⢮ * ClubBonusPrice,0.01);
                                                              END;
                                                               }
    { 7   ;   ;��ப� ��.          ;Integer       ;InitValue=0 }
    { 8   ;   ;���� �������        ;Decimal       ;OnValidate=BEGIN
                                                                //apik VALIDATE(�㬬�);
                                                                //apik 200716 (164531) > ᪨���
                                                                GetGSetup;
                                                                ClubBonusPrice := ConvBonusKCY("���� �������",TODAY);
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < ᪨���
                                                              END;
                                                               }
    { 9   ;   ;���譨� ����� ��.   ;Code20         }
    { 10  ;   ;����� ��        ;Option        ;OptionString=��������,�⬥����,��६�饭�,��࠭� }
    { 11  ;   ;��稭� ���ᠭ��    ;Option        ;OptionString=[ ,���ᠭ��,������,�訡�� ��樠��,�����] }
    { 12  ;   ;�६� �⬥�� ��  ;Time           }
    { 13  ;   ;�������� �⬥�� ��. ;Code10         }
    { 14  ;   ;�������� ���������� ��.;Code10      }
    { 15  ;   ;�������� ��������� ���⥩ ��.;Code10 }
    { 16  ;   ;�������� ����� ��樠�� ��.;Code10 }
    { 17  ;   ;�������� ��७�� �� ��. �⮫;Code10 }
    { 18  ;   ;�������� �� ���. ����;Code10    }
    { 19  ;   ;��稭� �⬥��      ;Option        ;OptionCaptionML=RUS=�⪠� ������,�訡�� ��樠��,�訡�� �����,������ �ਣ�⮢�����,�⮯-����,����� ������� �����,��ॡ�� �� ��ࢨ� ����,��ॡ�� �� ���筮�� ����,���� ���⪮�,�஬뢪� ��⥬�,���� �஫����,����;
                                                   OptionString=�⪠� ������,�訡�� ��樠��,�訡�� �����,������ �ਣ�⮢�����,�⮯-����,����� ������� �����,��ॡ�� �� ��ࢨ� ����,��ॡ�� �� ���筮�� ����,���� ���⪮�,�஬뢪� ��⥬�,���� �஫����,���� }
    { 20  ;   ;��� ������� ����७��;Code10       ;TableRelation="Unit of Measure" }
    { 21  ;   ;����࠭ �� ��.  ;Text4          }
    { 22  ;   ;����� �ਭ��      ;Integer        }
    { 23  ;   ;��� ������         ;Date           }
    { 24  ;   ;�६� ������        ;Time           }
    { 25  ;   ;��� ������         ;Date           }
    { 26  ;   ;�६� ������        ;Time           }
    { 1000;   ;��� ���� �ਣ�⮢�����;Code10      ;TableRelation="KR Hall";
                                                   OnValidate=BEGIN
                                                                VALIDATE("��� ���� �த���","��� ���� �ਣ�⮢�����");
                                                              END;
                                                               }
    { 1001;   ;�஭�஢���� ��.    ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_���. ����� ����࠭� ��������"."�஭�஢���� ��." WHERE (����� ��.=FIELD(����� ��.))) }
    { 1002;   ;������ ��.         ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_���. ����� ����࠭� ��������"."������ ����� ��." WHERE (����� ��.=FIELD(����� ��.))) }
    { 50010;  ;��� �⤥�� ��    ;Code10         }
    { 50011;  ;��� �஥�� ��   ;Code10         }
    { 50012;  ;��� ���� �த���    ;Code10        ;TableRelation="KR Hall";
                                                   OnValidate=BEGIN
                                                                IF NOT ����࠭����.GET("��� ���� �த���") THEN
                                                                  CLEAR(����࠭����);

                                                                //yuri 160715
                                                                "Sales Company" := ����࠭����.GetSalesCompany;
                                                              END;
                                                               }
    { 50016;  ;��७�ᥭ� �� ��㣮� �����;Boolean ;InitValue=No }
    { 50023;  ;��ய��⨥ ��.     ;Code20         }
    { 50024;  ;���� ��.            ;Code10        ;TableRelation="���. ���� ���������";
                                                   OnValidate=VAR
                                                                _recMenu@1000000000 : Record 21006013;
                                                              BEGIN
                                                                IF _recMenu.GET("���� ��.") THEN BEGIN
                                                                  IF _recMenu."Menu Type" = _recMenu."Menu Type" :: Buffet THEN
                                                                    "�ਧ��� ������" := "�ਧ��� ������" ::"����᪨� �⮫"
                                                                  ELSE
                                                                    "�ਧ��� ������" := "�ਧ��� ������" ::"�� ����";
                                                                END
                                                                ELSE
                                                                  "�ਧ��� ������" := "�ਧ��� ������" ::"�� ����";
                                                              END;
                                                               }
    { 50025;  ;��⠭�� ��� ��ப� ��.;Integer      }
    { 50026;  ;��⠭�� ��ப� ��.  ;Integer        }
    { 50029;  ;�㬬� ������        ;Decimal       ;InitValue=0 }
    { 50100;  ;�६����            ;Boolean        }
    { 50180;  ;�ਧ��� ������      ;Option        ;OnValidate=VAR
                                                                _recLine@1000000000 : Record 21001401;
                                                                _recLineNew@1000000003 : Record 21001401;
                                                                _recMenuLineLunch@1000000001 : Record 21026285;
                                                                _Qty@1000000004 : Decimal;
                                                                _recItem@1000000005 : Record 27;
                                                              BEGIN
                                                                IF ("�ਧ��� ������" = "�ਧ��� ������" :: "������ ����") AND ("��ப� ��." = "Main Line For Lunch") THEN BEGIN
                                                                  _recMenuLineLunch.SETRANGE("���㬥�� ��.", "���� ��.");
                                                                  _recMenuLineLunch.SETRANGE("��ப� ��.", "����� ����樨 � ����");
                                                                  _recMenuLineLunch.SETRANGE("����� ��.", "��� ��");
                                                                  _recMenuLineLunch.SETRANGE("��� ����樨", "��� ����樨");
                                                                  _recMenuLineLunch.SETFILTER("Qty Item", '>%1',0);
                                                                  IF _recMenuLineLunch.FINDSET THEN
                                                                  REPEAT
                                                                    _recLine.SETRANGE("����� ��.", "����� ��.");
                                                                    _recLine.SETRANGE("����� ��", _recLine."����� ��" :: ��࠭�);
                                                                    _recLine.SETRANGE("���� ��.","���� ��.");
                                                                    _recLine.SETFILTER("�ਧ��� ������", '<>%1',_recLine."�ਧ��� ������"::"������ ����");
                                                                    IF _recMenuLineLunch."Max Amount" > 0 THEN
                                                                      _recLine.SETFILTER("���� �������", '<=%1', _recMenuLineLunch."Max Amount");
                                                                    IF _recLine.FINDSET(TRUE) THEN
                                                                    REPEAT
                                                                      //_recMenuLine.SETRANGE("���㬥�� ��.", _recLine."���� ��.");
                                                                      //_recMenuLine.SETRANGE("����� ��.", _recLine."��� ��");
                                                                      //_recMenuLine.SETRANGE("��ப� ��.", _recLine."����� ����樨 � ����");
                                                                      //_recMenuLine.SETRANGE("��� ����樨", _recLine."��� ����樨");
                                                                      //_recMenuLine.SETFILTER("����� ��㯯� �����䨪�樨", _recMenuLineLunch."Class.Filter");
                                                                      //IF _recMenuLine.FINDFIRST THEN BEGIN
                                                                      _recItem.SETRANGE("No.", _recLine."��� ��");
                                                                      _recItem.SETFILTER("��࠭ ��㯯� �����䨪�樨",_recMenuLineLunch."Class.Filter");
                                                                      IF _recItem.FINDFIRST THEN BEGIN
                                                                        IF _recLine.������⢮ <= _recMenuLineLunch."Qty Item" THEN BEGIN
                                                                          _recLine.VALIDATE("���� �������", 0);
                                                                          _recLine.VALIDATE("Main Line For Lunch", "��ப� ��.");
                                                                          _recLine.VALIDATE("�ਧ��� ������", _recLine."�ਧ��� ������" ::"������ ����");
                                                                          _recLine.MODIFY;
                                                                        END
                                                                        ELSE BEGIN
                                                                          _recLineNew.INIT;
                                                                          _recLineNew.TRANSFERFIELDS(_recLine);
                                                                          _recLineNew.VALIDATE("��ப� ��.", _recLine."��ப� ��." + 1000);
                                                                          _recLineNew.VALIDATE(������⢮,_recLine.������⢮ - _recMenuLineLunch."Qty Item");
                                                                          _recLineNew.INSERT(TRUE);

                                                                          _recLine.VALIDATE(������⢮, _recMenuLineLunch."Qty Item");
                                                                          _recLine.VALIDATE("���� �������", 0);
                                                                          _recLine.VALIDATE("Main Line For Lunch", "��ப� ��.");
                                                                          _recLine.VALIDATE("�ਧ��� ������", _recLine."�ਧ��� ������" ::"������ ����");
                                                                          _recLine.MODIFY;
                                                                        END;

                                                                        _recMenuLineLunch."Qty Item" -= _recLine.������⢮;
                                                                      END;
                                                                    UNTIL (_recLine.NEXT = 0) OR (_recMenuLineLunch."Qty Item" <= 0);
                                                                  UNTIL _recMenuLineLunch.NEXT = 0;
                                                                END;
                                                              END;

                                                   OptionString=�� ����,������ ����,����᪨� �⮫;
                                                   Description=yuri 280815 }
    { 50200;  ;��।�             ;Integer        }
    { 50201;  ;�������਩         ;Text250        }
    { 50202;  ;�� ������        ;Boolean        }
    { 50300;  ;����� ��.           ;Integer        }
    { 50302;  ;Source Type         ;Option        ;CaptionML=RUS=��� ���筨��;
                                                   OptionCaptionML=RUS=�ନ���,������,���஭��� ����,ᠩ�;
                                                   OptionString=terminal,tablet,emenu,web;
                                                   Description=yuri 191114 }
    { 50303;  ;Source Code         ;Text30        ;TableRelation=IF (Source Type=CONST(terminal)) "_���� ����࠭� ����ன��".���
                                                                 ELSE IF (Source Type=FILTER(tablet|emenu)) Devices.ID;
                                                   CaptionML=RUS=��� ���筨��;
                                                   Description=yuri 191114 }
    { 50304;  ;Trans. Round        ;Integer       ;CaptionML=RUS=��㭤 �࠭���権;
                                                   Description=yuri 191114 }
    { 50305;  ;Table No.           ;Integer       ;TableRelation="����࠭ �⮫���"."�⮫�� ��.";
                                                   CaptionML=RUS=�⮫�� ��.;
                                                   Description=yuri 241114 }
    { 50500;  ;�� �ਣ�⮢����  ;Boolean       ;OnValidate=BEGIN
                                                                //apik 300420 (270316) > �஢����, �� ��⮢ �� �����
                                                                GetOrderHeader;
                                                                MODIFY;
                                                                UpdateOrderReady;
                                                                //apik 300420 (270316) <
                                                              END;
                                                               }
    { 50501;  ;Hall Y-Shift        ;Integer       ;TableRelation=Y-Shifts;
                                                   CaptionML=RUS=Y-����� ��� ���� }
    { 50502;  ;�� �� ��㯯�     ;Code10        ;TableRelation="_��㯯� ��� ���������" }
    { 50503;  ;����� ��         ;Integer        }
    { 50504;  ;Location Y-Shift    ;Integer       ;TableRelation=Y-Shifts;
                                                   CaptionML=RUS=Y-����� ��� ������ }
    { 50510;  ;��㭤 �����         ;Integer        }
    { 50517;  ;��� ������ ���ᠭ�� ;Code10        ;TableRelation=Location;
                                                   OnValidate=VAR
                                                                _recLC@1000000000 : Record 14;
                                                              BEGIN
                                                                UpdateLocation();

                                                                "Owner Company" := GetOwnerCompanyId("Sales Company","��� ������ ���ᠭ��");
                                                              END;
                                                               }
    { 50520;  ;��� �祩��          ;Code10        ;OnValidate=BEGIN
                                                                UpdateLocation();
                                                              END;
                                                               }
    { 50521;  ;��७�ᥭ� �� ������ ��.;Code20     }
    { 50522;  ;��७�ᥭ� � ������ ��.;Code20      }
    { 50523;  ;����� ����樨 � ����;Integer        }
    { 50550;  ;��� ����樨         ;Option        ;OptionString=�����,������ }
    { 50551;  ;���� ��㣨 ��⥬� ;Boolean        }
    { 50552;  ;��� ��⥬�         ;Integer       ;TableRelation="Restaurant External System" }
    { 50555;  ;���஢�� ������� ������;Code10     }
    { 50556;  ;��� ��㣨          ;Code10        ;TableRelation="Service Type" }
    { 50557;  ;DiscountCard        ;Text30         }
    { 51002;  ;������ �뤠��      ;Boolean        }
    { 52003;  ;��७�� �⮫�       ;Integer       ;Description=������ ᬥ�� �⮫� }
    { 52004;  ;��� ��㫨���        ;Integer       ;Description=���� ��㣨 � ��㫨���� }
    { 52005;  ;��� ���⥬� ��㫨���;Integer        }
    { 52006;  ;ClubBonusPrice      ;Decimal        }
    { 52007;  ;ClubBonusPriceSumm  ;Decimal        }
    { 52008;  ;ClubBonusAmount     ;Decimal        }
    { 52009;  ;�।�������         ;Decimal        }
    { 52010;  ;Tariff Extra System ;Code10        ;TableRelation="Wi-Fi Tariff".Code WHERE (Source Type=CONST(RST));
                                                   CaptionML=RUS=���� ���譥� ���⥬�;
                                                   Description=yuri 120814 (76892) }
    { 52011;  ;Wi-Fi Job Upload    ;Integer       ;CaptionML=RUS=Wi-Fi �஬����;
                                                   Description=yuri 120814 (76892) }
    { 52012;  ;Main Line For Lunch ;Integer       ;CaptionML=RUS=��ப� ����;
                                                   Description=yuri 040216 (128051) }
    { 52111;  ;�������� �⮫�      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_����� ����࠭� ���������".���������⮫� WHERE (����� ��.=FIELD(����� ��.))) }
    { 53003;  ;��⠭�� ���஡�� ��ப� ��.;Integer;Description=VAN 130115 }
    { 54001;  ;dim8                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(���������������� ��.));
                                                   OnLookup=VAR
                                                              _CUAdd@1101967000 : Codeunit 21001403;
                                                            BEGIN
                                                              _CUAdd.LookUpDim8(dim8);
                                                            END;

                                                   CaptionML=RUS=���ᠫ. ��. }
    { 54002;  ;��� �����           ;Code10        ;Description=yuri 100114 }
    { 54003;  ;Need MOL Order      ;Boolean       ;OnValidate=VAR
                                                                _RestManagerSetup@1000000000 : Record 21001400;
                                                                _Date@1000000001 : Date;
                                                                _recRestMOLLink@1000000002 : Record 21000006;
                                                              BEGIN
                                                                IF "Need MOL Order" THEN BEGIN
                                                                  _RestManagerSetup.GET();
                                                                  IF "�६� ������" < _RestManagerSetup."�६� ᤢ��� ���⭮��" THEN
                                                                    _Date := "��� ������" - 1
                                                                  ELSE
                                                                    _Date := "��� ������";

                                                                  IF "��� ����樨" = "��� ����樨" :: ����� THEN
                                                                    IF ("����� ��" = "����� ��"::��������) OR
                                                                       ("����� ��" = "����� ��"::�⬥����) AND NOT "�� �ਣ�⮢����" THEN BEGIN
                                                                      _recRestMOLLink.INIT;
                                                                      _recRestMOLLink.ID := 0;
                                                                      _recRestMOLLink."Rest.Order No." :=  "����� ��.";
                                                                      _recRestMOLLink."Rest.Order Line" := "��ப� ��.";
                                                                      _recRestMOLLink."Item No." :=  "��� ��";
                                                                      _recRestMOLLink."Location Code" := "��� ������ ���ᠭ��";
                                                                      _recRestMOLLink."Bin Code" :=  "��� �祩��";
                                                                      _recRestMOLLink."Posting Date" :=  _Date;
                                                                      _recRestMOLLink."Unit of Measure" :=  "��� ������� ����७��";
                                                                      _recRestMOLLink.Qty :=  ������⢮;
                                                                      _recRestMOLLink."Sale Hall Code" :=  "��� ���� �த���";
                                                                      _recRestMOLLink.INSERT(TRUE);

                                                                      "MOL Order No." := FORMAT(_recRestMOLLink.ID);
                                                                    END;

                                                                  IF "MOL Order No." = '' THEN
                                                                    "MOL Order No." := 'AAA';
                                                                END;
                                                              END;

                                                   CaptionML=RUS=����室��� ���;
                                                   Description=yuri 150517 }
    { 54004;  ;MOL Order No.       ;Code20        ;TableRelation="Order MOL Header";
                                                   CaptionML=RUS=����� ���;
                                                   Description=yuri 150517 }
    { 69000;  ;Bonus Discount Amount;Decimal      ;CaptionML=[ENU=Bonus Discount Amount;
                                                              RUS=�㬬� ����᭮� ᪨���];
                                                   Description=#36211 }
    { 69001;  ;Amount (ACY)        ;Decimal       ;CaptionML=[ENU=Amount (ACY);
                                                              RUS=�㬬� (���)];
                                                   Description=76691 }
    { 69002;  ;Disc. Amount (ACY)  ;Decimal       ;CaptionML=[ENU=Disc. Amount (ACY);
                                                              RUS=������ (���)];
                                                   Description=76691 }
    { 69003;  ;Bonus Disc. Amount (ACY);Decimal   ;CaptionML=[ENU=Bonus Disc. Amount (ACY);
                                                              RUS=����� (���)];
                                                   Description=76691 }
    { 69004;  ;�������� ��㯯� �����䨪�樨;Code20;
                                                   TableRelation="�����䨪��� ��㯯�".��� WHERE (���=CONST(����),
                                                                                                   �ਭ������� ���=CONST(Yes));
                                                   Description=76691 }
    { 69006;  ;Discount Code       ;Code10        ;TableRelation="Discount Code";
                                                   OnValidate=BEGIN
                                                                IF "Discount Code" = '' THEN BEGIN
                                                                  CLEAR("Discount Rule No.");
                                                                  CLEAR("Discount %");
                                                                END;
                                                              END;

                                                   CaptionML=RUS=��� ᪨��� }
    { 69007;  ;Discount Rule No.   ;Integer       ;TableRelation="Discount Rule";
                                                   CaptionML=[ENU=Rule No.;
                                                              RUS=����� �ࠢ���] }
    { 69008;  ;Discount %          ;Decimal       ;OnValidate=BEGIN
                                                                //apik 200716 (164531) > ᪨���
                                                                UpdateAmounts;
                                                                //apik 200716 (164531) < ᪨���
                                                              END;

                                                   CaptionML=[ENU=Discount %;
                                                              RUS=������ (%)];
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   AutoFormatType=2 }
    { 69009;  ;Parameter Code      ;Code10        ;TableRelation=Parameter;
                                                   CaptionML=[ENU=Code;
                                                              RUS=���] }
    { 69018;  ;Sales Company       ;Integer       ;CaptionML=[ENU=Sales Company;
                                                              RUS=�த��� �ଠ] }
    { 69019;  ;Owner Company       ;Integer       ;CaptionML=[ENU=Sales Company;
                                                              RUS=�������� �ଠ] }
    { 69020;  ;Storno Line No.     ;Integer       ;InitValue=0;
                                                   CaptionML=RUS=��୮ ��ப� ��. }
    { 21001400;;dim1               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 1=CONST(Yes));
                                                   CaptionML=RUS=����� ��� }
    { 21001401;;dim2               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 2=CONST(Yes));
                                                   CaptionML=RUS=����� ��� }
    { 21001402;;dim3               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 3=CONST(Yes));
                                                   CaptionML=RUS=��� ��ꥪ� }
    { 21001403;;dim4               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(����));
                                                   CaptionML=RUS=���� }
    { 21001404;;dim5               ;Code20        ;CaptionML=RUS=��㯯� ����� ���� }
    { 21001405;;dim6               ;Code20        ;TableRelation="_����㤭�� ����࠭�".��. WHERE (��.=FIELD(dim6));
                                                   CaptionML=RUS=��樠�� }
    { 21001406;;Storno Order No.   ;Code20        ;CaptionML=RUS=����� ��� ��୮ }
    { 21001509;;Hotel Guest No.    ;Code20        ;TableRelation=Guests;
                                                   CaptionML=RUS=����� �⥫� ��. }
    { 21001512;;Dim1 for Cost      ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 1=CONST(Yes));
                                                   CaptionML=RUS=�� ��� ����থ�;
                                                   Description=yuri 281117 }
    { 21001513;;Dim2 for Cost      ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dim 2=CONST(Yes));
                                                   CaptionML=RUS=�� ��� ����থ�;
                                                   Description=yuri 281117 }
  }
  KEYS
  {
    {    ;����� ��.,��ப� ��.                    ;SumIndexFields=�㬬�,�㬬� ������;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;����� ��.,���譨� ����� ��.,����� ��;SumIndexFields=�㬬�;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,��� ��,����� ��,���� �������,��� ��㣨;
                                                   SumIndexFields=������⢮,�㬬� ������,ClubBonusAmount;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,��� ��,����� ��,���� �������,��㭤 �����;
                                                   SumIndexFields=������⢮,�㬬� ������;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,�� �� ��㯯�,����� ��,����� ��;
                                                   SumIndexFields=������⢮,�㬬�;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,��� ��,�� �� ��㯯�,����� ��,����� ��,Need MOL Order,MOL Order No.;
                                                   SumIndexFields=������⢮;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,�� �� ��㯯�,����� ��  ;SumIndexFields=�㬬�;
                                                   MaintainSIFTIndex=No }
    {    ;��।�                                  }
    {    ;��㭤 �����                              }
    {    ;����� ��.,��� ��,����� ��,���� �������,��㭤 �����,���� ��.,����� ����樨 � ����;
                                                   SumIndexFields=������⢮,�㬬� ������;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,��� ��,����� ��,���� �������,���� ��.,����� ����樨 � ����;
                                                   SumIndexFields=������⢮,�㬬�;
                                                   MaintainSIFTIndex=No }
    {    ;����� ��.,����� ��.,��।�,��ப� ��.   }
    {    ;��� ������,�६� ������                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ����㤭��@1000000000 : Record 5200;
      ��⌥��������@1000000001 : Record 21006013;
      ��⌥���ப�@1000000002 : Record 21006014;
      ���������࠭����������@1000000003 : Record 21001417;
      ��@1000000004 : Record 27;
      ����࠭����@1000000005 : Record 21001418;
      ���������࠭���ப�@1000000007 : Record 21001401;
      CUAdd@1000000008 : Codeunit 21001403;
      DiscountMgt@1000000009 : Codeunit 21007071;
      DiscountCode@1000000010 : Record 21001516;
      RoundMethod@1000000011 : Record 42;
      DiscAmount@1000000012 : Decimal;
      RoundIt@1000000013 : Boolean;
      ClubGSetup@1000000018 : Record 21007451;
      CurrencyLoc@1000000017 : Record 4;
      CurrencyKOR@1000000016 : Record 4;
      GSetupRead@1000000015 : Boolean;
      CurrExchRate@1000000014 : Record 330;
      HS@1000000006 : Record 21007001;
      ���᠍���ன��@1000000020 : Record 21001415;
      PMSFunc@1000000019 : Codeunit 21002101;
      PreserveParams@1000000021 : Boolean;

    PROCEDURE SetDimentions@1000000000();
    VAR
      MenuHeader@1000000000 : Record 21006013;
      MenuLine@1000000001 : Record 21006014;
      GSetup@1000000002 : Record 21001400;
      halls@1000000003 : Record 21001418;
      header@1000000004 : Record 21001417;
      _DefDim@1101967000 : Record 352;
      _tProjectScheduler@1101967001 : Record 21001506;
      _RR@1000000005 : Record 21002128;
      _TEventHeader@1000000007 : Record 21002200;
      _TEventType@1000000006 : Record 21002219;
      Dim4Fixed@1000000008 : Boolean;
      _recDigSig@1000000009 : Record 21006032;
    BEGIN
      IF NOT GSetup.GET() THEN
        GSetup.INIT;
      header.GET("����� ��.");

      IF dim4 <> '' THEN
        Dim4Fixed := TRUE;

      //========================================================
      //��
      dim8 := GSetup.Dim8;

      IF halls.GET("��� ���� �த���") THEN BEGIN
        dim1 := halls.Dim1;
         IF halls."Fixed Dim4" THEN BEGIN
           Dim4Fixed := halls."Fixed Dim4";
           dim4 := halls.Dim4;
         END;

         IF _DefDim.GET(DATABASE::"KR Hall","��� ���� �த���",GSetup."Shortcut Dimension 8 Code") THEN
            dim8 := _DefDim."Dimension Value Code";
      END;

      //========================================================
      //��
      IF MenuHeader.GET("���� ��.") THEN
        IF MenuHeader.Dim1 <> '' THEN BEGIN
          dim1 := MenuHeader.Dim1;
          IF MenuHeader."Fixed Dim4" THEN BEGIN
            Dim4Fixed := MenuHeader."Fixed Dim4";
            dim4 := MenuHeader.Dim4;
          END;
        END;


      //========================================================
      //������ �������
      IF MenuLine.GET("���� ��.","��� ��","����� ����樨 � ����","��� ����樨") THEN BEGIN
        dim2 := MenuLine.Dim2;
        dim5 := FORMAT(MenuLine.DimGroup);
      END;

      //========================================================
      //��� �������
      dim3 := _tProjectScheduler.GetDim3("��� ���� �த���",CREATEDATETIME("��� ������","�६� ������"));

      IF header.dim3 <> '' THEN
        dim3 := header.dim3;

      //========================================================
      //����
      IF NOT Dim4Fixed THEN BEGIN
        dim4 := GSetup.Dim4;
        IF MenuHeader.GET("���� ��.") THEN
          IF MenuHeader.Dim4 <> '' THEN
            dim4 := MenuHeader.Dim4
          ELSE IF MenuHeader."Menu Type" = MenuHeader."Menu Type"::Service THEN
            dim4 := GSetup.Dim4Compl;
      END;
      IF MenuHeader.Dim3 <> '' THEN
        dim3 := MenuHeader.Dim3;
      IF MenuLine.Dim3 <> '' THEN
        dim3 := MenuLine.Dim3;
      IF (header."�஭�஢���� ��." <> '') THEN BEGIN
        IF _TEventHeader.GET(header."�஭�஢���� ��.") THEN BEGIN
          dim3 := _TEventHeader.dim3;

          IF NOT Dim4Fixed THEN BEGIN
            IF _TEventHeader.dim4 <> '' THEN
              dim4 := _TEventHeader.dim4
            ELSE IF _TEventType.GET(_TEventHeader."��� ��ய����") THEN
              dim4 := _TEventType."Dimension 4 Value";
          END
        END ELSE
          IF _RR.GET(header."�஭�஢���� ��.") THEN
            IF _RR.dim3 <> '' THEN
              dim3 := _RR.dim3;

        IF NOT Dim4Fixed THEN
          //yuri 291117
          //IF (STRPOS(GSetup."������ �� �������ࠬ � ���.", header."�஭�஢���� ��.") <> 0) OR
          //   (STRPOS(CUAdd.NOTServicePM("��� ���� �த���"), header."�஭�஢���� ��.") <> 0) THEN
          IF header."���஢�� ������� ������" <> '' THEN
            dim4 := GSetup.Dim4Compl;
      END;

      //yuri 301117
      IF _recDigSig.GET(header."���஢�� ������� ������") THEN BEGIN
        "Dim1 for Cost" := _recDigSig."Dim1 for Cost";
        "Dim2 for Cost" := _recDigSig."Dim2 for Cost";
      END;

      IF dim4 = GSetup.Dim4Compl THEN
        dim3 := '';
    END;

    PROCEDURE GetDocDimensions@1000000001(VAR TempDimDoc@1000000000 : Record 357);
    VAR
      GSetup@1000000001 : Record 21001400;
      GLSetup@1000000002 : Record 98;
    BEGIN
      //apik 280415 (104159) ������� ᮢ���⨬� ����७��
      GLSetup.GET;
      GSetup.GET;
      IF dim1 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GLSetup."Global Dimension 1 Code";
        TempDimDoc."Dimension Value Code" := dim1;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim3 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GLSetup."Global Dimension 2 Code";
        TempDimDoc."Dimension Value Code" := dim2;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim3 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 3 Code";
        TempDimDoc."Dimension Value Code" := dim3;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim4 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 4 Code";
        TempDimDoc."Dimension Value Code" := dim4;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
      IF dim8 <> '' THEN BEGIN
        TempDimDoc."Dimension Code" := GSetup."Shortcut Dimension 8 Code";
        TempDimDoc."Dimension Value Code" := dim8;
        IF TempDimDoc."Dimension Code" <> '' THEN
          IF TempDimDoc.INSERT THEN;
      END;
    END;

    PROCEDURE GetOwnerCompanyId@1000000002(CompanyId@1000000003 : Integer;LocationCode@1000000000 : Code[20]) OwnerId : Integer;
    VAR
      recLocation@1000000004 : Record 14;
      recICPartner@1000000001 : Record 413;
      recCompany@1000000002 : Record 2000000006;
    BEGIN
      //apik 170715 ����祭�� ����� ��� 宧鶴� ⮢��
      OwnerId := CompanyId; //default
      IF PMSFunc.FindById(CompanyId,recCompany) THEN BEGIN
        recLocation.CHANGECOMPANY(recCompany.Name);
        recICPartner.CHANGECOMPANY(recCompany.Name);
        IF recLocation.GET(LocationCode) AND
          recICPartner.GET(recLocation."IC Partner Owner") AND
          (recICPartner."Inbox Type" = recICPartner."Inbox Type"::Database) AND
          recCompany.GET(recICPartner."Inbox Details") THEN
           OwnerId := recCompany."No.";
      END;
    END;

    PROCEDURE UpdateLocation@1000000006();
    VAR
      _recHallLocRepl@1000000000 : Record 21026288;
    BEGIN
      IF _recHallLocRepl.GET("���� ��.", "��� ���� �த���", "��� ������ ���ᠭ��", "��� �祩��") THEN BEGIN
        "��� ������ ���ᠭ��" := _recHallLocRepl."New Location Code";
        "��� �祩��" := _recHallLocRepl."New Bin Code";
      END;
    END;

    PROCEDURE UpdateAmounts@1000000003();
    BEGIN
      //apik 200716 (164531) ᪨���
      �㬬� := ROUND(������⢮ * "���� �������",0.01);
      ClubBonusPriceSumm := ROUND(������⢮ * ClubBonusPrice,0.01);
      IF "Discount Code" <> '' THEN
        IF DiscountCode.GET("Discount Code") THEN
        IF NOT DiscountCode."Price Change" THEN BEGIN
          RoundIt := RoundMethod.GET(DiscountCode."Rounding Method");
          DiscAmount := �㬬� * "Discount %" / 100;
          IF RoundIt THEN
            DiscAmount := RoundMethod.RoundAmount(DiscAmount);
          "�㬬� ������" := DiscAmount;
        END;
    END;

    PROCEDURE GetGSetup@1101967001();
    VAR
      _cuKR@1000000000 : Codeunit 21002204;
    BEGIN
      //apik 271213 (36211) �⠥� ����ன�� ����ᮢ
      IF NOT GSetupRead THEN BEGIN
        ���᠍���ன��.RESET;
        ���᠍���ன��.SETRANGE("��ନ��� ��.", _cuKR.GetComputerName);
        ���᠍���ன��.SETRANGE("��� ����","��� ���� �த���");
        IF NOT ���᠍���ன��.FINDFIRST THEN
          CLEAR(���᠍���ன��);

        IF ���᠍���ன��."���� ����" <> '' THEN BEGIN
           ���᠍���ன��.RESET;
           ���᠍���ன��.SETRANGE(���,���᠍���ன��."���� ����");
           ���᠍���ன��.SETRANGE("��ନ��� ��.", _cuKR.GetComputerName);
           IF NOT ���᠍���ன��.FINDFIRST THEN
             CLEAR(���᠍���ன��);
        END;
        HS.GetLocal;
        IF ���᠍���ன��.��� = '' THEN
          ���᠍���ன��.ClubRegin := HS."Club Region Code";
        CLEAR(ClubGSetup);

        IF ���᠍���ன��.ClubRegin <> '' THEN
          ClubGSetup.GET(���᠍���ன��.ClubRegin)
        ELSE
          ClubGSetup.FINDFIRST;

      //  BonusActive := ClubGSetup."Bonus Service Type" <> '';
        CurrencyLoc.InitRoundingPrecision;
        CurrencyKOR.InitRoundingPrecision;
        IF CurrencyKOR.GET(ClubGSetup."Bonus Currency Code") THEN;
        GSetupRead := TRUE;
      END;
    END;

    PROCEDURE ConvBonusLCY@1000000063(AmtKCY@1000000000 : Decimal;aDate@1000000001 : Date) AmtLCY : Decimal;
    BEGIN
      //apik 051113 (53158)
      //assert: �⠯ ��㡠 ���⠭
      AmtLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(aDate,ClubGSetup."Bonus Currency Code",AmtKCY,
         CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
         CurrencyLoc."Amount Rounding Precision");
    END;

    PROCEDURE ConvBonusKCY@1000000064(AmtLCY@1000000000 : Decimal;aDate@1000000001 : Date) AmtKCY : Decimal;
    BEGIN
      //apik 051113 (53158)
      //assert: �⠯ ��㡠 ���⠭
      AmtKCY := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(aDate,ClubGSetup."Bonus Currency Code",AmtLCY,
         CurrExchRate.ExchangeRate(aDate,ClubGSetup."Bonus Currency Code")),
         CurrencyKOR."Amount Rounding Precision");
    END;

    PROCEDURE GetOrderHeader@1000000005();
    BEGIN
      IF ���������࠭����������."����� ��." <> "����� ��." THEN
        IF NOT ���������࠭����������.GET("����� ��.") THEN
          CLEAR(���������࠭����������);
    END;

    PROCEDURE UpdateOrderReady@1000000004();
    VAR
      ROL@1000000000 : Record 21001401;
      AllItemsReady@1000000001 : Boolean;
    BEGIN
      ROL.SETRANGE("����� ��.", "����� ��.");
      ROL.SETFILTER("����� ��", '<>%1', ROL."����� ��"::�⬥����);
      ROL.SETRANGE("��� ����樨", ROL."��� ����樨"::�����);
      ROL.SETRANGE("�� �ਣ�⮢����", FALSE);
      AllItemsReady := ROL.ISEMPTY;
      IF ���������࠭����������."����� ������" = ���������࠭����������."����� ������"::�������� THEN BEGIN
          IF AllItemsReady THEN BEGIN
            ���������࠭����������."����� ������" := ���������࠭����������."����� ������"::��⮢�;
            ���������࠭����������.MODIFY;
          END;
      END ELSE
        IF ���������࠭����������."����� ������" = ���������࠭����������."����� ������"::��⮢� THEN
          IF NOT AllItemsReady THEN BEGIN
            ���������࠭����������."����� ������" := ���������࠭����������."����� ������"::��������;
            ���������࠭����������.MODIFY;
          END;
    END;

    PROCEDURE CalcColor@1000000007() : Integer;
    VAR
      _recItem@1000000000 : Record 27;
      _ColorRed@1000000001 : Integer;
      _ColorYellow@1000000002 : Integer;
      _ColorBlue@1000000003 : Integer;
      _ColorBlack@1000000004 : Integer;
    BEGIN
      //yuri 170914  >
      _ColorRed := 1000;
      _ColorYellow := 98498;
      _ColorBlack := 0;
      _ColorBlue := 16711680;

      CASE "����� ��" OF
        "����� ��" :: �������� :
          BEGIN
            IF _recItem.GET("��� ��") AND _recItem."�� � ����⮩ 業��" THEN
              EXIT(_ColorYellow);
            EXIT(_ColorBlack);
          END;
        "����� ��" :: �⬥���� :
          EXIT(_ColorRed);
        ELSE
          EXIT(_ColorBlack);
      END;
      //yuri 170914 <
    END;

    PROCEDURE CopyMenuParams@1000000009();
    VAR
      OrderParams@1000000000 : Record 21000725;
      MenuParms@1000000001 : Record 21000724;
      ParamOpt@1000000002 : Record 21000722;
      MenuLine@1000000003 : Record 21006014;
    BEGIN
      //apik 161020 (270316) ��ࠬ����
      GetOrderHeader;
      MenuParms.SETRANGE("���� ��.", "���� ��.");
      MenuParms.SETRANGE("���� ����� ��.", "��� ��");
      MenuParms.SETRANGE("���� ��ப� ��.", "����� ����樨 � ����");
      MenuParms.SETRANGE("���� ⨯ ����樨", "��� ����樨");
      IF MenuParms.FINDSET THEN
      REPEAT
        OrderParams.INIT;
        OrderParams."����� ��." := "����� ��.";
        OrderParams."��ப� ��." := "��ப� ��.";
        OrderParams."Parameter Code" := MenuParms."Parameter Code";
        OrderParams."Parameter Description" := MenuParms."Parameter Description";
        OrderParams."Parameter Type" := MenuParms."Parameter Type";
        OrderParams."Parameter Flag" := MenuParms."Parameter Flag";
        OrderParams."���� ��." := "���� ��.";
        OrderParams."Option Quantity" := 1;
        OrderParams.VALIDATE("Parameter Value", MenuParms."Parameter Value");
        IF OrderParams."Parameter Type" IN
          [OrderParams."Parameter Type"::"Item Option"..OrderParams."Parameter Type"::"Resource Option"] THEN BEGIN
            IF ParamOpt.GET(OrderParams."Parameter Code", OrderParams."Parameter Option") THEN
              OrderParams."Option Quantity" := ParamOpt.Quantity;
            AddParamOrderLine(Rec, OrderParams);
        END;
        OrderParams.INSERT(TRUE);
      UNTIL MenuParms.NEXT = 0;
    END;

    PROCEDURE DeleteLineParams@1000000010();
    VAR
      LineParms@1000000001 : Record 21000725;
    BEGIN
      //apik 161020 (270316) ��ࠬ����
      LineParms.SETRANGE("����� ��.", "����� ��.");
      LineParms.SETRANGE("��ப� ��.", "��ப� ��.");
      IF NOT LineParms.ISEMPTY THEN
        LineParms.DELETEALL(TRUE);
    END;

    PROCEDURE AddParamOrderLine@1000000008(ROL@1000000000 : Record 21001401;VAR OrderParams@1000000001 : Record 21000725);
    VAR
      NewLineNo@1000000002 : Integer;
      NewROL@1000000003 : Record 21001401;
      MenuLine@1000000004 : Record 21006014;
    BEGIN
      //apik 161020 (270316) ��ࠬ����
      GetOrderHeader;
      IF NOT MenuLine.GET(ROL."���� ��.",OrderParams."���. ����� ��.",
        OrderParams."���� ��ப� ��.",OrderParams."���. ⨯ ����樨") THEN EXIT;
      IF MenuLine.�����஢��� THEN EXIT;
      IF ���������࠭����������."��� ��砫� ������" < MenuLine."���� �� ����" THEN EXIT;
      IF (MenuLine."���� �� ����" <> 0D) AND
         (���������࠭����������."��� ��砫� ������" > MenuLine."���� �� ����") THEN EXIT;

      NewROL.SETRANGE("����� ��.", "����� ��.");
      IF NewROL.FINDLAST THEN
        NewLineNo := NewROL."��ப� ��.";
      IF NewLineNo < ROL."��ப� ��." THEN  // �� ��砩 ����⠢������ ����饩 ��ப�
        NewLineNo := ROL."��ப� ��.";
      NewLineNo += 10;

      NewROL := ROL; // ����஢��� ����� �����
      NewROL."��ப� ��." := NewLineNo;
      NewROL."��� ����樨" := OrderParams."���. ⨯ ����樨";
      NewROL."����� ����樨 � ����" := OrderParams."���� ��ப� ��.";
      NewROL."��� ������� ����७��" := MenuLine."��� ������� ����७��";
      NewROL.VALIDATE("��� ��", OrderParams."���. ����� ��.");
      NewROL.VALIDATE("���� �������", 0);
      NewROL.VALIDATE(������⢮, OrderParams."Option Quantity" * ROL.������⢮);
      NewROL.�������� := COPYSTR(MenuLine."�� ��������",1,30);
      NewROL.�।������� := MenuLine.����⭠����;
      NewROL.VALIDATE("��� ������ ���ᠭ��", MenuLine."��� ������ ���ᠭ��");
      NewROL.VALIDATE("��� �祩��", MenuLine."��� �祩��");
      NewROL."Main Line For Lunch" := ROL."��ப� ��.";
      NewROL.INSERT;

      OrderParams."���. ��ப� ��." := NewLineNo;
    END;

    PROCEDURE ShowParameters@1000000011();
    VAR
      OrderParams@1000000000 : Record 21000725;
    BEGIN
      OrderParams.SETRANGE("����� ��.", "����� ��.");
      OrderParams.SETRANGE("��ப� ��.", "��ப� ��.");
      FORM.RUNMODAL(0, OrderParams);
    END;

    PROCEDURE SetPreserveParams@1000000012(aFlag@1000000000 : Boolean);
    BEGIN
      PreserveParams := aFlag;
    END;

    PROCEDURE UpdateParametersFrom@1000000013(VAR TempOLP@1000000000 : Record 21000725);
    VAR
      OrderParams@1000000001 : Record 21000725;
      ParamOpt@1000000002 : Record 21000722;
    BEGIN
      //apik 211020 (270316) ��ࠬ���� �� ���譥� ⠡���� (��⠥� ��䨫��஢�����)
      DeleteLineParams;
      IF "��� ����樨" <> "��� ����樨"::����� THEN EXIT;

      GetOrderHeader;
      IF TempOLP.FINDSET THEN
      REPEAT
        OrderParams.INIT;
        OrderParams."����� ��." := "����� ��.";
        OrderParams."��ப� ��." := "��ப� ��.";
        OrderParams.VALIDATE("Parameter Code", TempOLP."Parameter Code");
        OrderParams.VALIDATE("Parameter Flag", TempOLP."Parameter Flag");
        OrderParams."Parameter Description" := TempOLP."Parameter Description";
        OrderParams."���� ��." := "���� ��.";
        OrderParams."Option Quantity" := 1;
        OrderParams.VALIDATE("Parameter Option", TempOLP."Parameter Option");
        IF OrderParams."Parameter Type" IN
          [OrderParams."Parameter Type"::"Item Option"..OrderParams."Parameter Type"::"Resource Option"] THEN BEGIN
            IF ParamOpt.GET(OrderParams."Parameter Code", OrderParams."Parameter Option") THEN
              OrderParams."Option Quantity" := ParamOpt.Quantity;
            AddParamOrderLine(Rec, OrderParams);
        END;
        OrderParams.INSERT(TRUE);
      UNTIL TempOLP.NEXT = 0;
    END;

    BEGIN
    {
      yuri > 28.05.13 + Dim8 ���ᠫ. ��.
      apik 251214 (91420) ��᫥������� ���� Dim3 (��� ��ꥪ�) �� ����
      apik 280415 (104159) ��������� ������ 䨪�஢����� ����
      VAN 130115 ��������� ���� "��⠭�� ���஡�� ��ப� ��."
      apik 200716 (164579) +��樨 � ���� ��稭� �⬥��
      apik 200716 (164531) ᪨���
              ���������࠭���ப�."���� �������" := D;
              ���������࠭���ப�.VALIDATE(�㬬�, ROUND(_������� * D,0.01));
              ���������࠭���ப�.ClubBonusPrice := ConvBonusKCY(���������࠭���ப�."���� �������",TODAY);
              ���������࠭���ப�.ClubBonusPriceSumm := ConvBonusKCY(���������࠭���ப�.�㬬�,TODAY);
    }
    END.
  }
}

