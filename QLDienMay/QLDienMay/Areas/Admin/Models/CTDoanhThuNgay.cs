using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QLDienMay.Areas.Admin.Models
{
    public class CTDoanhThuNgay
    {
        public DateTime NgayGio { get; set; }
        public string MaDonHang { get; set; }
        public string Loai { get; set; }
        public decimal TongTienHoaDon { get; set; }
    }
}