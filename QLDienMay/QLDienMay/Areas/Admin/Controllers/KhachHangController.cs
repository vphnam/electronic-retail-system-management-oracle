using PagedList;
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
    public class KhachHangController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/KhachHang
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            string quyen = (string)Session["Quyen"];
            if (quyen == "CV001")
            {
                if (id != null && id != "")
                {
                    return View(db.KHACHHANGs.Where(n => n.MAKHACHHANG.StartsWith(id)).ToList().OrderBy(n => n.MAKHACHHANG).ToPagedList(page, pageSize));
                }
                else
                    return View(db.KHACHHANGs.ToList().OrderBy(n => n.MAKHACHHANG).ToPagedList(page, pageSize));
            }   
            else
            {
                if (id != null && id != "")
                {
                    return View(db.KHACHHANGs.Where(n => n.MAKHACHHANG.StartsWith(id)).ToList().OrderBy(n => n.MAKHACHHANG).ToPagedList(page, pageSize));
                }
                else
                    return View(db.KHACHHANGs.ToList().OrderBy(n => n.MAKHACHHANG).ToPagedList(page, pageSize));
            }
        }
        public ActionResult Create()
        {
            try
            {
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                KHACHHANG kh = new KHACHHANG();
                return View(kh);
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập, vui lòng thử lại sau!", "error");
                return RedirectToAction("Index", "PhienTruyCap");
            }
        }
        [HttpPost]
        public ActionResult Create(KHACHHANG khEn)
        {
            try
            {
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                string pass = Encryptor.ComputeSha256Hash(khEn.MATKHAU);
                db.PROC_DANG_KY_KHACH_HANG(khEn.TENKHACHHANG, khEn.SDT, khEn.DIACHI, khEn.THANHPHO, khEn.EMAIL, khEn.TAIKHOAN, khEn.MATKHAU, return_value);
                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 1)
                    SetAlert("Lỗi: Số điện thoại khách hàng bị trùng!", "warning");
                else if (kq == 2)
                    SetAlert("Lỗi: Email khách hàng bị trùng!", "warning");
                else if (kq == 3)
                    SetAlert("Lỗi: Tài khoản khách hàng bị trùng!", "warning");
                else if (kq == 0)
                {
                    SetAlert("Tạo mới khách hàng thành công!", "success");
                    return RedirectToAction("Index");
                }
                else
                    SetAlert("Lỗi: Lỗi khi thêm mới khách hàng, vui lòng thử lại sau!", "error");
                return View(khEn);
            }
            catch
            {
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                return View(khEn);
            }
        }

        public ActionResult Edit(string id)
        {
            try
            {
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                KHACHHANG kh = db.KHACHHANGs.Find(id);
                if (kh != null)
                    return View(kh);
                else
                {
                    SetAlert("Lỗi: Mã khách hàng không tồn tại!", "error");
                    return RedirectToAction("Index");
                }
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập, vui lòng thử lại sau!", "error");
                return RedirectToAction("Index", "PhienTruyCap");
            }
        }
        [HttpPost]
        public ActionResult Edit(KHACHHANG khEn, string id)
        {
            try
            {
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                string pass = Encryptor.ComputeSha256Hash(khEn.MATKHAU);
                db.PROC_UPDATE_KHACH_HANG(id, khEn.TENKHACHHANG.Trim(), khEn.SDT.Trim(), khEn.DIACHI.Trim(), khEn.THANHPHO, khEn.EMAIL, return_value);
                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 1)
                    SetAlert("Lỗi: Số điện thoại khách hàng bị trùng!", "warning");
                else if (kq == 2)
                    SetAlert("Lỗi: Email khách hàng bị trùng!", "warning");
                else if (kq == 0)
                {
                    SetAlert("Cập nhật khách hàng thành công!", "success");
                    return RedirectToAction("Index");
                }
                else
                    SetAlert("Lỗi: Lỗi khi cập nhật khách hàng, vui lòng thử lại sau!", "error");
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                return View(khEn);
            }
            catch
            {
                ViewBag.ThanhPho = db.THANHPHOes.ToList();
                return View(khEn);
            }
            
        }
        public ActionResult CapNhatTrangThai(string id, string trangThai)
        {
            try
            {
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_UPDATE_TINH_TRANG_KHACH_HANG(id, trangThai,return_value);
                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 1)
                    SetAlert("Lỗi: Không tìm thấy khách hàng!", "warning");
                else if (kq == 0)
                {
                    SetAlert("Cập nhật tình trạng khách hàng thành công!", "success");
                }
                else
                    SetAlert("Lỗi: Cập nhật tình trạng khách hàng thất bại!", "error");
                return RedirectToAction("Index");
            }
            catch
            {
                SetAlert("Lỗi: Cập nhật trạng thái khách hàng thất bại, vui lòng thử lại sau", "error");
                return RedirectToAction("Index");
            }
        }
    }
}