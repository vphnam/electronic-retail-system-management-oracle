using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace QLDienMay.Areas.Admin.Models
{
    public class SanPhamEntity
    {
        public SanPhamEntity()
        {
            ANHMINHHOA = "~/Images/add.png";
        }
        public string MASANPHAM { get; set; }
        public string TENSANPHAM { get; set; }
        public string ANHMINHHOA { get; set; }
        public decimal DONGIA { get; set; }
        public string MAKHUYENMAI { get; set; }
        public HttpPostedFileBase UploadImage { get; set; }
        public string TRANGTHAI { get; set; }
    }
}