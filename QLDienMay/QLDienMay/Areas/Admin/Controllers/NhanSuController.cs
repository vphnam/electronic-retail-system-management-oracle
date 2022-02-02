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
    public class NhanSuController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/NhanSu
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
                string quyen = (string)Session["Quyen"];
                if (quyen == "CV001")
                {
                    if (id != null && id != "")
                    {
                        return View(db.NHANVIENs.Where(n => n.MANHANVIEN.StartsWith(id)).ToList().OrderBy(n => n.MANHANVIEN).ToPagedList(page, pageSize));
                    }
                    else
                        return View(db.NHANVIENs.ToList().OrderBy(n => n.MANHANVIEN).ToPagedList(page, pageSize));
                }
                else
                {
                    if (id != null && id != "")
                    {
                        return View(db.NHANVIENs.Where(n => n.CUAHANG1.MACUAHANG == nv.CUAHANG1.MACUAHANG && n.MANHANVIEN.StartsWith(id)).ToList().OrderBy(n => n.MANHANVIEN).ToPagedList(page, pageSize));
                    }
                    else
                        return View(db.NHANVIENs.Where(n => n.CUAHANG1.MACUAHANG == nv.CUAHANG1.MACUAHANG).ToList().OrderBy(n => n.MANHANVIEN).ToPagedList(page, pageSize));
                }
            }
            catch
            {
                SetAlert("Lỗi: Có lỗi xảy ra trong quá trình, vui lòng thử lại sau!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult Create()
        {
            try
            {
                ViewBag.ChucVu = db.CHUCVUs.ToList();
                ViewBag.CuaHang = db.CUAHANGs.ToList();
                NHANVIEN nv = new NHANVIEN();
                return View(nv);
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập, vui lòng thử lại sau!", "error");
                return RedirectToAction("Index","PhienTruyCap");
            }
        }
        [HttpPost]
        public ActionResult Create(NHANVIEN nvEn)
        {
            ViewBag.ChucVu = db.CHUCVUs.ToList();
            ViewBag.CuaHang = db.CUAHANGs.ToList();
            try
            {
                if(ModelState.IsValid)
                {
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    string pass = Encryptor.ComputeSha256Hash(nvEn.MATKHAU);
                    db.PROC_INSERT_NHAN_VIEN(nvEn.TENNHANVIEN, nvEn.NGAYSINH, nvEn.SDT, nvEn.EMAIL, nvEn.DIACHI, nvEn.GIOITINH, nvEn.CHUCVU, nvEn.CUAHANG, nvEn.HINHTHUC, nvEn.TAIKHOAN, pass, "0", return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 1)
                        SetAlert("Lỗi: Số điện thoại nhân viên bị trùng!", "warning");
                    else if (kq == 2)
                        SetAlert("Lỗi: Email nhân viên bị trùng!", "warning");
                    else if (kq == 3)
                        SetAlert("Lỗi: Tài khoản nhân viên bị trùng!", "warning");
                    else if (kq == 0)
                    {
                        SetAlert("Tạo mới nhân viên thành công!", "success");
                        return RedirectToAction("Index");
                    }
                    else
                        SetAlert("Lỗi: Lỗi khi thêm mới nhân viên, vui lòng thử lại sau!", "error");

                    return View(nvEn);
                }
                else
                {
                    
                    return View(nvEn);
                }
            }
            catch
            {

                return View(nvEn);
            }
        }
        public ActionResult Edit(string id)
        {
            try
            {
                ViewBag.ChucVu = db.CHUCVUs.ToList();
                ViewBag.CuaHang = db.CUAHANGs.ToList();
                NHANVIEN nv = db.NHANVIENs.Find(id);
                if(nv != null)
                {
                    nv.TAIKHOAN = nv.TAIKHOAN.Trim();
                    return View(nv);
                }      
                else
                {
                    SetAlert("Lỗi: Mã nhân viên không tồn tại!", "error");
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
        public ActionResult Edit(NHANVIEN nvEn, string id)
        {
            ViewBag.ChucVu = db.CHUCVUs.ToList();
            ViewBag.CuaHang = db.CUAHANGs.ToList();

                if(ModelState.IsValid)
                {
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    string pass = Encryptor.ComputeSha256Hash(nvEn.MATKHAU);
                    db.PROC_UPDATE_NHAN_VIEN(id, nvEn.TENNHANVIEN.Trim(), nvEn.NGAYSINH, nvEn.SDT.Trim(), nvEn.EMAIL.Trim(), nvEn.DIACHI.Trim(), nvEn.GIOITINH, nvEn.CHUCVU, nvEn.CUAHANG, nvEn.HINHTHUC, nvEn.TAIKHOAN.Trim(), pass, nvEn.TRANGTHAI, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 1)
                        SetAlert("Lỗi: Số điện thoại nhân viên bị trùng!", "warning");
                    else if (kq == 2)
                        SetAlert("Lỗi: Email nhân viên bị trùng!", "warning");
                    else if (kq == 3)
                        SetAlert("Lỗi: Tài khoản nhân viên bị trùng!", "warning");
                    else if (kq == 4)
                        SetAlert("Lỗi: Không tìm thấy mã nhân viên cần cập nhật!", "warning");
                    else if (kq == 0)
                    {
                        SetAlert("Cập nhật nhân viên thành công!", "success");
                        return RedirectToAction("Index");
                    }
                    else
                        SetAlert("Lỗi: Lỗi khi cập nhật nhân viên, vui lòng thử lại sau!", "error");
                    
                    return View(nvEn);
                }
                else
                {
                    return View(nvEn);
                }

        }
        public ActionResult CapNhatTrangThai(string id, string trangThai)
        {
            try
            {
                NHANVIEN nvEn = db.NHANVIENs.Find(id);
                if (nvEn != null)
                {
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    db.PROC_UPDATE_NHAN_VIEN(nvEn.MANHANVIEN, nvEn.TENNHANVIEN, nvEn.NGAYSINH, nvEn.SDT, nvEn.EMAIL, nvEn.DIACHI, nvEn.GIOITINH, nvEn.CHUCVU, nvEn.CUAHANG, nvEn.HINHTHUC, nvEn.TAIKHOAN, nvEn.MATKHAU, trangThai, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 0)
                        SetAlert("Cập nhật trạng thái thành công!", "success");
                    else
                        SetAlert("Lỗi: Lỗi khi cập nhật trạng thái nhân viên, vui lòng thử lại sau!", "error");
                    return RedirectToAction("Index");
                }
                else
                {
                    SetAlert("Lỗi: không thể tìm thấy nhân viên!", "error");
                    return RedirectToAction("Index");
                }
            }
            catch
            {
                SetAlert("Lỗi: không thể tìm thấy nhân viên!", "error");
                return RedirectToAction("Index");
            }
        }
    }
}