# Çağrı Merkezi Performans Analizi (SQL + Power BI)
> **English Title:** Call Center Performance Analysis (SQL + Power BI)

## İş Senaryosu

Bir çağrı merkezi operasyonunun temel hedefi, gelen çağrıların en az %90'ını 60 saniye içerisinde cevaplamaktır.

Bu projede çağrı merkezi performansı analiz edilerek SLA hedeflerinin karşılanıp karşılanmadığı değerlendirilmiş, yoğunluk oluşan gün ve saatler belirlenmiş ve operasyonel iyileştirme fırsatları ortaya çıkarılmıştır.

---

## Proje Hakkında

Bu proje kapsamında çağrı merkezi operasyon verileri SQL kullanılarak temizlenmiş, dönüştürülmüş ve analiz edilmiştir.

Analiz sonuçları Power BI dashboardları ile görselleştirilerek çağrı hacmi, bekleme süreleri, hizmet seviyeleri (SLA) ve operasyonel performans göstergeleri değerlendirilmiştir.

---

## İş Problemi

Aşağıdaki sorulara cevap aranmıştır:

- Çağrı merkezi %90 SLA hedefini karşılıyor mu?
- En yoğun günler hangileri?
- En yoğun saatler hangileri?
- Bekleme süreleri operasyon performansını nasıl etkiliyor?
- Operasyonel iyileştirme gerektiren noktalar nereler?

---

## Kullanılan Teknolojiler

- **SQL (MySQL)**
  - Veri temizleme
  - Bekleme ve hizmet sürelerinin yeniden hesaplanması
  - SLA metriğinin oluşturulması
  - Analitik view'ların oluşturulması

- **Power BI**
  - KPI kartları
  - Line Chart
  - Bar Chart
  - Donut Chart
  - Operasyonel dashboard tasarımı

---

## Veri Seti

**Kaynak Dosya:** `simulated_call_centre.csv`

Veri seti simüle edilmiş çağrı merkezi operasyon kayıtlarından oluşmaktadır.

İçerdiği başlıca alanlar:

- Çağrı Tarihi
- Çağrı Başlangıç Saati
- Çağrı Cevaplanma Saati
- Çağrı Bitiş Saati
- Bekleme Süresi
- Hizmet Süresi
- SLA Durumu

**Toplam Kayıt Sayısı:** 51.708 Çağrı

---

## SQL Süreci

### Veri Temizleme

Analiz öncesinde aşağıdaki işlemler gerçekleştirilmiştir:

- Tarih alanlarının dönüştürülmesi
- Saat alanlarının dönüştürülmesi
- Bekleme sürelerinin yeniden hesaplanması
- Hizmet sürelerinin yeniden hesaplanması
- SLA göstergesinin yeniden oluşturulması

### Oluşturulan Analitik Görünümler

- `v_kpi_summary`
- `v_weekday_performance`
- `v_hourly_performance`
- `v_daily_performance`
- `v_wait_time_distribution`
- `v_workload_vs_service`

### Raporlama Katmanı

Power BI raporlarında kullanılmak üzere ayrı bir raporlama katmanı oluşturulmuştur.

---

## Dashboard 1 – Çağrı Merkezi Genel Performans Görünümü

### KPI Göstergeleri

- Toplam Çağrı Sayısı
- SLA Başarı Oranı
- Ortalama Bekleme Süresi
- Ortalama Hizmet Süresi

### Temel Bulgular

- SLA başarı oranı %91,82 ile hedefin üzerinde gerçekleşmiştir.
- Ortalama bekleme süresi 17 saniyedir.
- En yüksek çağrı hacmi Cuma günü gerçekleşmiştir.
- Çağrıların %87,6'sı beklemeden cevaplanmıştır.

---

## Dashboard 2 – Operasyonel Performans Analizi

### Görselleştirmeler

- Saatlik SLA Performansı
- Saatlik Ortalama Bekleme Süresi
- Çağrı Hacmi ve SLA İlişkisi
- Gün Bazında SLA Performansı

### Operasyonel Bulgular

- SLA performansı saat 13:00 civarında düşüş göstermektedir.
- Ortalama bekleme süresi saat 13:00'te en yüksek seviyeye ulaşmaktadır.
- En yüksek SLA performansı Çarşamba günü gözlemlenmiştir.
- Çağrı hacmi gün boyunca genel olarak dengeli seyretmiştir.

---

## Proje Yapısı

<pre>
call-center-performance-analysis-sql-powerbi/
│
├── data/
│   └── simulated_call_centre.csv
│
├── powerbi/
│   ├── dashboard_1_call_center_overview.png
│   └── dashboard_2_call_center_operational_analysis.png
│
├── sql/
│   └── call_center_performance_analysis.sql
│
└── README.md
</pre>

---

## Sonuç

Analiz sonuçlarına göre çağrı merkezi %90 SLA hedefini aşarak %91,82 başarı oranına ulaşmıştır.

Bununla birlikte özellikle öğle saatlerinde bekleme sürelerinin arttığı ve SLA performansının zayıfladığı görülmektedir. Bu durum, yoğun saatlerde iş gücü planlamasının optimize edilmesiyle operasyonel performansın daha da iyileştirilebileceğini göstermektedir.
