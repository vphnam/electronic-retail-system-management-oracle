using PagedList;
using QLDienMay.Areas.Admin.Models;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class SanPhamController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/SanPham
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                if (id != null && id != "")
                {
                    return View(db.SANPHAMs.Where(x => x.MASANPHAM.StartsWith(id)).OrderBy(x => x.MASANPHAM).ToPagedList(page, pageSize));
                }
                else
                {
                    return View(db.SANPHAMs.ToList().OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
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
            SanPhamEntity sp = new SanPhamEntity();
            return View(sp);
        }
        [HttpPost]
        public ActionResult Create(SanPhamEntity spEn)
        {
            try
            {
                string filename = Path.GetFileNameWithoutExtension(spEn.UploadImage.FileName);
                string extent = Path.GetExtension(spEn.UploadImage.FileName);
                filename = filename + extent;
                spEn.ANHMINHHOA = "~/Images/" + filename;
                spEn.UploadImage.SaveAs(Path.Combine(Server.MapPath("~/Images/"), filename));
                if (System.IO.File.Exists(Path.Combine(Server.MapPath("~/Images/"), filename)))
                {
                    ModelState.AddModelError("", "Ảnh đã được sử dụng");
                    return View(spEn);
                }
                else
                {
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    db.PROC_INSERT_SAN_PHAM(spEn.TENSANPHAM, spEn.ANHMINHHOA, spEn.DONGIA, spEn.MAKHUYENMAI, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 0)
                    {
                        SetAlert("Thêm mới sản phẩm thành công!", "success");
                        return RedirectToAction("Index", "SanPham");
                    }
                    else if (kq == 1)
                    {
                        SetAlert("Lỗi, Tên sản phẩm bị trùng, vui lòng chọn tên mới!", "error");
                        return View(spEn);
                    }
                    else
                    {
                        SetAlert("Lỗi, vui lòng kiểm tra lại thông tin và thử lại!", "error");
                        return View(spEn);
                    }    
                } 

            }
            catch
            {
                SetAlert("Lỗi:Tạo mới sản phẩm thất bại", "error");
                return View(spEn);
            }
        }
        public ActionResult Edit(string id)
        {
            try
            {
                ViewBag.KhuyenMai = db.KHUYENMAIs.ToList();
                SANPHAM sp = db.SANPHAMs.Find(id);

                SanPhamEntity spEn = new SanPhamEntity();

                spEn.MASANPHAM = id;
                spEn.TENSANPHAM = sp.TENSANPHAM;
                if (sp.ANHMINHHOA != null)
                {
                    spEn.ANHMINHHOA = sp.ANHMINHHOA;
                    Session["mon_image"] = sp.ANHMINHHOA;
                }
                spEn.DONGIA = sp.DONGIA;
                spEn.MAKHUYENMAI = sp.MAKHUYENMAI;

                return View(spEn);
            }
            catch
            {
                SetAlert("Lỗi: Có lỗi xảy ra trong quá trình, vui lòng thử lại sau!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        [HttpPost]
        public ActionResult Edit(SanPhamEntity spEn, string id)
        {

            if (ModelState.IsValid)
            {
                try
                {
                    if (spEn.UploadImage != null)
                    {
                        string filename = Path.GetFileNameWithoutExtension(spEn.UploadImage.FileName);
                        string extent = Path.GetExtension(spEn.UploadImage.FileName);
                        filename = filename + extent;
                        spEn.ANHMINHHOA = "~/Images/" + filename;
                        spEn.UploadImage.SaveAs(Path.Combine(Server.MapPath("~/Images/"), filename));
                        /*if (System.IO.File.Exists(Path.Combine(Server.MapPath("~/Images/"), filename)))
                        {
                            ModelState.AddModelError("", "Ảnh đã được sử dụng");
                            return View(spEn);
                        }*/
                    }
                    else
                        spEn.ANHMINHHOA = (string)Session["mon_image"];

                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    db.PROC_UPDATE_SAN_PHAM(id,spEn.TENSANPHAM,spEn.ANHMINHHOA,spEn.DONGIA,spEn.MAKHUYENMAI,spEn.TRANGTHAI, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 0)
                    {
                        SetAlert("Thêm mới sản phẩm thành công!", "success");
                        return RedirectToAction("Index", "SanPham");
                    }
                    else if (kq == 1)
                    {
                        SetAlert("Lỗi, Tên sản phẩm bị trùng, vui lòng chọn tên mới!", "error");
                        return View(spEn);
                    }
                    else
                    {
                        SetAlert("Lỗi, vui lòng kiểm tra lại thông tin và thử lại!", "error");
                        return View(spEn);
                    }
                }
                catch
                {
                    SetAlert("Lỗi:Tạo mới sản phẩm thất bại", "error");
                    return View(spEn);
                }
            }
            return View(spEn);
        }
        public ActionResult KhoaSanPham(string id, string trangThai)
        {
            try
            {
                if (id != null)
                {
                    SANPHAM sp = db.SANPHAMs.Find(id);
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    db.PROC_UPDATE_SAN_PHAM(id, sp.TENSANPHAM, sp.ANHMINHHOA, sp.DONGIA, sp.MAKHUYENMAI, trangThai, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == 0)
                    {
                        SetAlert("Khóa sản phẩm " + id + " thành công", "success");
                        return RedirectToAction("Index", "SanPham");
                    }
                    else
                    {
                        SetAlert("Lỗi, khóa trạng thái sản phẩm " + id + " thất bại!", "error");
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    SetAlert("Lỗi, không tìm thấy thông tin sản phẩm cần khóa!", "error");
                    return RedirectToAction("Index");
                }
            }
            catch
            {
                SetAlert("Lỗi, khóa trạng thái sản phẩm " + id + " thất bại!", "error");
                return RedirectToAction("Index");
            }
        }
        public ActionResult SelectKM()
        {
            KHUYENMAI se_km = new KHUYENMAI();
            se_km.ListKM = db.KHUYENMAIs.ToList<KHUYENMAI>();
            return PartialView(se_km);
        }
    }
}