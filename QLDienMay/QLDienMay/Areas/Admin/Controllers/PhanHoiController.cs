using PagedList;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class PhanHoiController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/PhanHoi
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                string quyen = (string)Session["Quyen"];
                if (quyen == "CV001")
                {
                    if (id != null && id != "")
                    {
                        return View(db.PHANHOIs.Where(n => n.MAPHANHOI.StartsWith(id)).ToList().OrderBy(n => n.MAPHANHOI).ToPagedList(page, pageSize));
                    }
                    else
                        return View(db.PHANHOIs.ToList().OrderBy(n => n.MAKHACHHANG).ToPagedList(page, pageSize));
                }
                else
                {
                    if (id != null && id != "")
                    {
                        return View(db.PHANHOIs.Where(n => n.MAPHANHOI.StartsWith(id)).ToList().OrderBy(n => n.MAPHANHOI).ToPagedList(page, pageSize));
                    }
                    else
                        return View(db.PHANHOIs.ToList().OrderBy(n => n.MAPHANHOI).ToPagedList(page, pageSize));
                }
            }
            catch
            {
                SetAlert("Lỗi: Có lỗi xảy ra trong quá trình, vui lòng kiểm tra lại thông tin!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult XuLyPhanHoi(string id)
        {
            try
            {
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_XU_LY_PHAN_HOI(id, return_value);
                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 1)
                    SetAlert("Lỗi: Không tìm thấy mã phản hồi!", "warning");
                else if (kq == 0)
                {
                    SetAlert("Xử lý phản hồi khách hàng thành công!", "success");
                }
                else
                    SetAlert("Lỗi: Không thể xử lý phản hồi!", "error");
                return RedirectToAction("Index");
            }
            catch
            {
                SetAlert("Lỗi: Xử lý phản hồi thất bại, vui lòng thử lại sau", "error");
                return RedirectToAction("Index");
            }
        }
    }
}