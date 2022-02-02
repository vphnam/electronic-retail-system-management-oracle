using QLDienMay.Code;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class PhienTruyCapController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult DangNhap()
        {
            List<CHUCVU> lstCv = db.CHUCVUs.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult DangNhap(NHANVIEN nvEn)
        {
            try
            {
                string pass = Encryptor.ComputeSha256Hash(nvEn.MATKHAU);
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                ObjectParameter return_id = new ObjectParameter("rETURN_ID", typeof(string));
                db.PROC_DANG_NHAP(nvEn.TAIKHOAN, pass, 1, return_value, return_id);
                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 1)
                {
                    ViewData["LoiDN_NV"] = "Tài khoản không tồn tại!";
                }
                else if (kq == 2)
                    ViewData["LoiDN_NV"] = "Sai mật khẩu!";
                else if (kq == 3)
                    ViewData["LoiDN_NV"] = "Tài khoản đã bị khóa!";
                else if (kq == -1)
                    ViewData["LoiDN_NV"] = "Lỗi không xác định!";
                else
                {
                    string id = return_id.Value.ToString().Trim();
                    NHANVIEN nv = db.NHANVIENs.SingleOrDefault(n => n.MANHANVIEN == id);
                    Session["NhanVien"] = nv;
                    Session["MaNhanVien"] = nv.MANHANVIEN;
                    Session["Quyen"] = nv.CHUCVU1.MACHUCVU;
                    SetAlert("Đăng nhập thành công!", "success");
                    return RedirectToAction("Index");
                }
                return View();
            }
            catch
            {
                return View();
            } 
        }
        public ActionResult DangXuat()
        {
            try
            {
                Session["Quyen"] = null;
                Session["NhanVien"] = null;
                Session["MaNhanVien"] = null;
                return RedirectToAction("DangNhap");
            }
            catch
            {
                SetAlert("Lỗi: Xử lý phản hồi thất bại, vui lòng thử lại", "error");
                return RedirectToAction("Index");
            }
        }
        public ActionResult KhongTheTruyCap()
        {
            return View();
        }
    }
}