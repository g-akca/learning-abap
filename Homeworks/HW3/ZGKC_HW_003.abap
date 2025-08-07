*&---------------------------------------------------------------------*
*& Report ZGKC_HW_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgkc_hw_003.

DATA: gs_ogrenci_t TYPE zgkc_ogrenci_t,
      gs_islem_t TYPE zgkc_islem_t,
      gs_kitap_t TYPE zgkc_kitap_t,
      gv_ogrno TYPE nriv-nrlevel,
      gv_islemno TYPE nriv-nrlevel,
      gv_kitapno TYPE nriv-nrlevel.

SELECTION-SCREEN BEGIN OF BLOCK options WITH FRAME TITLE TEXT-001.
PARAMETERS: p_std  RADIOBUTTON GROUP gr1 USER-COMMAND usr DEFAULT 'X',
            p_prc  RADIOBUTTON GROUP gr1,
            p_book RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK options.

SELECTION-SCREEN BEGIN OF BLOCK new_student WITH FRAME TITLE TEXT-002.
PARAMETERS: p_sno    TYPE zgkc_ogrno_de MODIF ID sno,
            p_sname  TYPE zgkc_ograd_de MODIF ID std,
            p_ssname TYPE zgkc_ogrsoyad_de MODIF ID std,
            p_sgnd   TYPE zgkc_cinsiyet_de MODIF ID std,
            p_sdt    TYPE zgkc_dtarih_de MODIF ID std,
            p_sclass TYPE zgkc_sinif_de MODIF ID std,
            p_spoint TYPE zgkc_puan_de MODIF ID std.
SELECTION-SCREEN END OF BLOCK new_student.

SELECTION-SCREEN BEGIN OF BLOCK new_process WITH FRAME TITLE TEXT-003.
PARAMETERS: p_pno  TYPE zgkc_islemno_de MODIF ID pno,
            p_psno  TYPE zgkc_ogrno_de MATCHCODE OBJECT ZGKC_HW_003_SH MODIF ID prc,
            p_pbno  TYPE zgkc_kitapno_de MATCHCODE OBJECT ZGKC_HW_003_SH2 MODIF ID prc,
            p_pat  TYPE zgkc_atarih_de MODIF ID prc,
            p_pvt  TYPE zgkc_vtarih_de MODIF ID prc.
SELECTION-SCREEN END OF BLOCK new_process.

SELECTION-SCREEN BEGIN OF BLOCK new_book WITH FRAME TITLE TEXT-004.
PARAMETERS: p_bno   TYPE zgkc_kitapno_de MODIF ID bno,
            p_bname TYPE zgkc_kitapad_de MODIF ID bo,
            p_byno  TYPE zgkc_yazarno_de MATCHCODE OBJECT ZGKC_HW_003_SH3 MODIF ID bo,
            p_btno  TYPE zgkc_turno_de MATCHCODE OBJECT ZGKC_HW_003_SH4 MODIF ID bo,
            p_bpage TYPE zgkc_sayfasayisi_de MODIF ID bo.
SELECTION-SCREEN END OF BLOCK new_book.

INCLUDE ZGKC_HW_003_FRM.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'SNO' OR screen-group1 = 'PNO' OR screen-group1 = 'BNO'.
      screen-input = 0.
    ENDIF.

    IF screen-group1 = 'STD' OR screen-group1 = 'PRC'
    OR screen-group1 = 'BO' OR screen-group1 = 'SNO'
    OR screen-group1 = 'PNO' OR screen-group1 = 'BNO'.
      screen-active = 0.
      IF p_std = abap_true AND ( screen-group1 = 'STD' OR screen-group1 = 'SNO' ).
        screen-active = 1.

        SELECT SINGLE NRLEVEL
        FROM NRIV
        WHERE OBJECT = 'ZGKC_OGR'
        INTO @gv_ogrno.

        p_sno = gv_ogrno.
      ELSEIF p_prc = abap_true AND ( screen-group1 = 'PRC' OR screen-group1 = 'PNO' ).
        screen-active = 1.

        SELECT SINGLE NRLEVEL
        FROM NRIV
        WHERE OBJECT = 'ZGKC_ISLEM'
        INTO @gv_islemno.

        p_pno = gv_islemno.
      ELSEIF p_book = abap_true AND ( screen-group1 = 'BO' OR screen-group1 = 'BNO' ).
        screen-active = 1.

        SELECT SINGLE NRLEVEL
        FROM NRIV
        WHERE OBJECT = 'ZGKC_KITAP'
        INTO @gv_kitapno.

        p_bno = gv_kitapno.
      ENDIF.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.
  IF p_std = abap_true.
    PERFORM insert_student.
  ELSEIF p_prc = abap_true.
    PERFORM insert_process.
  ELSEIF p_book = abap_true.
    PERFORM insert_book.
  ENDIF.