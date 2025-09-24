# Observations and Conclusion
Pada Percobaan ini telah dilakukan perbandingan antara Ephemeral State Management dengan App State Management menggunakan scoped_model.

Pada Ephemeral State Management, state dikelola secara langsung di dalam widget menggunakan setState(). Pendekatan ini cukup sederhana dan mudah dipahami, namun hanya berlaku secara lokal pada widget tersebut. Jika widget di-rebuild atau berpindah halaman, state dapat hilang. Oleh karena itu, metode ini lebih cocok digunakan pada aplikasi kecil atau kasus sederhana, seperti menangani input form atau perubahan tampilan sementara.

Sementara itu, pada App State Management dengan scoped_model, state dikelola dalam sebuah model terpisah (CounterModel) yang dapat diakses oleh banyak widget dalam aplikasi. Perubahan state dilakukan dengan memanggil notifyListeners(), sehingga semua widget yang berlangganan (ScopedModelDescendant) akan otomatis menerima pembaruan. Pendekatan ini membuat state tetap konsisten di seluruh aplikasi dan lebih mudah dikelola ketika jumlah widget bertambah banyak.

Secara keseluruhan, dapat disimpulkan bahwa:
1. Ephemeral State lebih sesuai untuk aplikasi kecil atau fitur yang sifatnya sederhana dan lokal.
2. App State dengan scoped_model lebih sesuai untuk aplikasi menengah hingga besar, karena lebih efisien, terstruktur, dan mampu mengelola state secara global.