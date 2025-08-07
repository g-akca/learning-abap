*&---------------------------------------------------------------------*
*& Include          ZGKC_HW_003_FRM
*&---------------------------------------------------------------------*

FORM insert_student.
  IF p_sname = ' ' OR p_ssname = ' ' OR p_sclass = ' ' OR p_spoint = ' '.
    WRITE 'Lütfen ad, soyad, sınıf, ve puan alanlarını doldurunuz.'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr = '01'
      object      = 'ZGKC_OGR'
    IMPORTING
      number      = p_sno.

  gs_ogrenci_t-ogrno = p_sno.
  gs_ogrenci_t-ograd = p_sname.
  gs_ogrenci_t-ogrsoyad = p_ssname.
  gs_ogrenci_t-cinsiyet = p_sgnd.
  gs_ogrenci_t-dtarih = p_sdt.
  gs_ogrenci_t-sinif = p_sclass.
  gs_ogrenci_t-puan = p_spoint.

  INSERT zgkc_ogrenci_t FROM gs_ogrenci_t.

  WRITE 'Öğrenci başarıyla eklendi.'.
ENDFORM.

FORM insert_process.
  IF p_psno = ' ' OR p_pbno = ' ' OR p_pat = ' '.
    WRITE 'Lütfen öğrenci no, kitap no, ve alış tarihi alanlarını doldurunuz.'.
    EXIT.
  ENDIF.

  DATA: lv_bcount TYPE int1,
        lv_spoint TYPE int4,
        lv_checkogr TYPE zgkc_ogrno_de,
        lv_checkkitap TYPE zgkc_kitapno_de,
        lv_checkislem TYPE zgkc_islemno_de.

  SELECT SINGLE COUNT(*)
  FROM zgkc_ogrenci_t
  WHERE ogrno = @p_psno
  INTO @lv_checkogr.

  SELECT SINGLE COUNT(*)
  FROM zgkc_kitap_t
  WHERE kitapno = @p_pbno
  INTO @lv_checkkitap.

  IF lv_checkogr = 0.
    WRITE 'Lütfen sistemde mevcut bir öğrenci no giriniz!'.
    EXIT.
  ELSEIF lv_checkkitap = 0.
    WRITE 'Lütfen sistemde mevcut bir kitap no giriniz!'.
    EXIT.
  ENDIF.

  SELECT SINGLE COUNT(*)
  FROM zgkc_islem_t
  WHERE ogrno = @p_psno AND vtarih = '00000000'
  INTO @lv_bcount.

  SELECT SINGLE puan
  FROM zgkc_ogrenci_t
  WHERE ogrno = @p_psno
  INTO @lv_spoint.

  IF lv_spoint <= 25 AND lv_bcount = 1.
    WRITE 'Bu öğrenci sadece 1 kitap alabilir.'.
    EXIT.
  ELSEIF lv_spoint <= 50 AND lv_bcount = 2.
    WRITE 'Bu öğrenci sadece 2 kitap alabilir.'.
    EXIT.
  ELSEIF lv_spoint <= 75 AND lv_bcount = 3.
    WRITE 'Bu öğrenci sadece 3 kitap alabilir.'.
    EXIT.
  ELSEIF lv_bcount = 4.
    WRITE 'Bu öğrenci sadece 4 kitap alabilir.'.
    EXIT.
  ENDIF.

  SELECT SINGLE COUNT(*)
  FROM zgkc_islem_t
  WHERE kitapno = @p_pbno AND vtarih = '00000000'
  INTO @lv_checkislem.

  IF lv_checkislem <> 0.
    WRITE 'Bu kitap henüz kütüphaneye geri verilmedi.'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr = '01'
      object      = 'ZGKC_ISLEM'
    IMPORTING
      number      = p_pno.

  gs_islem_t-islemno = p_pno.
  gs_islem_t-ogrno = p_psno.
  gs_islem_t-kitapno = p_pbno.
  gs_islem_t-atarih = p_pat.
  gs_islem_t-vtarih = p_pvt.

  INSERT zgkc_islem_t FROM gs_islem_t.

  WRITE 'İşlem başarıyla eklendi.'.
ENDFORM.

FORM insert_book.
  IF p_bname = ' '.
    WRITE 'Lütfen kitap adı alanını doldurunuz.'.
    EXIT.
  ENDIF.

  DATA: lv_checkyazar TYPE zgkc_yazarno_de,
        lv_checktur TYPE zgkc_turno_de.

  SELECT SINGLE COUNT(*)
  FROM zgkc_yazar_t
  WHERE yazarno = @p_byno
  INTO @lv_checkyazar.

  SELECT SINGLE COUNT(*)
  FROM zgkc_tur_t
  WHERE turno = @p_btno
  INTO @lv_checktur.

  IF lv_checkyazar = 0.
    WRITE 'Lütfen sistemde mevcut bir öğrenci no giriniz!'.
    EXIT.
  ELSEIF lv_checktur = 0.
    WRITE 'Lütfen sistemde mevcut bir kitap no giriniz!'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr = '01'
      object      = 'ZGKC_KITAP'
    IMPORTING
      number      = p_bno.

  gs_kitap_t-kitapno = p_bno.
  gs_kitap_t-kitapad = p_bname.
  gs_kitap_t-yazarno = p_byno.
  gs_kitap_t-turno = p_btno.
  gs_kitap_t-sayfasayisi = p_bpage.

  INSERT zgkc_kitap_t FROM gs_kitap_t.

  WRITE 'Kitap başarıyla eklendi.'.
ENDFORM.