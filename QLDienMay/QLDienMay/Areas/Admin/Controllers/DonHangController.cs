using OfficeOpenXml;
using PagedList;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class DonHangController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
            string quyen = (string)Session["Quyen"];
            if (quyen == "CV001")
            {
                if(id != null && id != "")
                {
                    return View(db.DONHANGs.Where(n => n.MADONHANG.StartsWith(id)).ToList().OrderBy(n => n.MADONHANG).ToPagedList(page, pageSize));
                }
                else
                    return View(db.DONHANGs.ToList().OrderBy(n => n.MADONHANG).ToPagedList(page, pageSize));
            }      
            else
            {
                if (id != null && id != "")
                {
                    return View(db.DONHANGs.Where(n => n.MADONHANG.StartsWith(id) && n.MACUAHANG == nv.CUAHANG1.MACUAHANG).ToList().OrderBy(n => n.MADONHANG).ToPagedList(page, pageSize));
                }
                else
                    return View(db.DONHANGs.Where(n => n.MACUAHANG == nv.CUAHANG1.MACUAHANG).ToList().OrderBy(n => n.MADONHANG).ToPagedList(page, pageSize));
            }
        }
        public ActionResult XacNhan(string id, string confirm)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];

                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_XAC_NHAN_DON_HANG(id, maNv, confirm, return_value);

                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 0)
                {
                    SetAlert("Cập nhật tình trạng xác nhận đơn hàng " + id + " thành công!", "success");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 1)
                {
                    SetAlert("Lỗi, Tình trạng xác nhận đơn hàng " + id + " đã được cập nhật từ trước!", "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else
                {
                    SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng " + id, "error");
                    return RedirectToAction("Index", "DonHang");
                }
            }
            catch
            {
                SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng " + id, "error");
                return RedirectToAction("Index", "DonHang");
            }
        }
        public ActionResult ThanhToan(string id, string confirm)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];

                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_THANH_TOAN_DON_HANG(id, maNv, confirm, return_value);

                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 0)
                {
                    SetAlert("Cập nhật tình trạng thanh toán đơn hàng " + id + " thành công!", "success");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 1)
                {
                    SetAlert("Lỗi, Tình trạng thanh toán của đơn hàng " + id + " đã được cập nhật từ trước!", "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else
                {
                    SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng " + id, "error");
                    return RedirectToAction("Index", "DonHang");
                }
            }
            catch
            {
                SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng " + id, "error");
                return RedirectToAction("Index", "DonHang");
            }
        }
        public ActionResult GiaoHang(string id, string confirm)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];

                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_TINH_TRANG_GIAO_HANG(id, maNv, confirm, return_value);

                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 0)
                {
                    SetAlert("Cập nhật tình trạng giao hàng đơn hàng " + id + " thành công!", "success");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 2)
                {
                    SetAlert("Lỗi, Tình trạng giao hàng của đơn hàng " + id + " đã được cập nhật từ trước!", "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 3)
                {
                    SetAlert("Lỗi, Đơn hàng " + id + " vẫn chưa được xuất kho!", "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 4)
                {
                    SetAlert("Lỗi, vui lòng kiểm tra lại thông tin đơn hàng " + id, "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 1)
                {
                    SetAlert("Lỗi, vui lòng kiểm tra lại thông tin đơn hàng " + id, "error");
                    return RedirectToAction("Index", "DonHang");
                }
                else
                {
                    SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng!", "error");
                    return RedirectToAction("Index", "DonHang");
                }
            }
            catch
            {
                SetAlert("Lỗi, vui lòng kiểm tra lại đơn hàng!", "error");
                return RedirectToAction("Index", "DonHang");
            }
        }
        public ActionResult XemChiTietDon(string id, int page = 1, int pageSize = 30)
        {
            NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
            DONHANG dh = db.DONHANGs.SingleOrDefault(n => n.MADONHANG == id);
            if(dh != null)
            {
                if(nv.CUAHANG1.MACUAHANG == dh.MACUAHANG)
                {
                    ViewBag.MaDonHang = id;
                    PHIEUXUAT px = db.PHIEUXUATs.Where(n => n.MADONHANG == id).FirstOrDefault();
                    if (px == null)
                        ViewBag.XuatPhieu = true;
                    return View(db.CHITIETDONHANGs.Where(n => n.MADONHANG == id).OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
                }
                else
                {
                    SetAlert("Lỗi, bạn không thể xem thông tin này!", "error");
                    return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
                }
            }   
            else
            {
                SetAlert("Lỗi, không tìm thấy thông tin đơn hàng!", "warning");
                return RedirectToAction("Index");
            }
        }
        public ActionResult XuatKhoVaPhieuBH(string id)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];
                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                db.PROC_XUAT_PHIEU_XUAT_VA_BAO_HANH(maNv, id, return_value);

                int kq = int.Parse(string.Format("{0}", return_value.Value));
                if (kq == 0)
                {
                    SetAlert("Xuất kho đơn hàng " + id + " thành công!", "success");
                    return RedirectToAction("Index", "DonHang");
                }
                else if (kq == 1)
                {
                    SetAlert("Lỗi: Kiểm tra lại dữ liệu đầu vào và thử lại!", "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
                else if (kq == 2)
                {
                    SetAlert("Đơn hàng " + id + " chưa được xác nhận!", "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
                else if (kq == 3)
                {
                    SetAlert("Đơn hàng " + id + " đã được xuất kho từ trước!", "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
                else if (kq == 4)
                {
                    SetAlert("Không đủ hàng để xuất kho cho đơn hàng " + id, "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
                else
                {
                    SetAlert("Lỗi: Vui lòng kiểm tra lại thông tin đơn!", "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
            }
            catch
            {
                SetAlert("Lỗi: Vui lòng kiểm tra lại thông tin đơn!", "error");
                return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
            }
            
        }
        public ActionResult XuatHoaDon(string id)
        {
            try
            {
                DONHANG dh = db.DONHANGs.Find(id);
                if (dh != null)
                {
                    List<CHITIETDONHANG> lstCTDH = db.CHITIETDONHANGs.Where(n => n.MADONHANG == id).ToList();
                    decimal tongTien = db.CHITIETDONHANGs.Where(n => n.MADONHANG == id).Sum(n => n.THANHTIEN);
                    decimal khuyenMai = tongTien - (decimal)dh.TONGGIATRI;
                    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                    ExcelPackage pck = new ExcelPackage();
                    ExcelWorksheet ws = pck.Workbook.Worksheets.Add("HoaDon");

                    ws.Cells["B2"].Value = "HÓA ĐƠN";

                    ws.Cells["A4"].Value = "MÃ ĐƠN HÀNG";
                    ws.Cells["B4"].Value = id;

                    ws.Cells["C4"].Value = "TÊN KHÁCH HÀNG";
                    ws.Cells["D4"].Value = dh.KHACHHANG.TENKHACHHANG.ToString();

                    ws.Cells["A5"].Value = "NHÂN VIÊN PHỤ TRÁCH";
                    if (dh.NHANVIENPHUTRACH != null)
                    {
                        ws.Cells["B5"].Value = dh.NHANVIEN.TENNHANVIEN.ToString();
                    }
                    else
                    {
                        ws.Cells["B5"].Value = "";
                    }

                    ws.Cells["C5"].Value = "CỬA HÀNG";
                    ws.Cells["D5"].Value = dh.CUAHANG.DIACHI.ToString();

                    DateTime timeDat = (DateTime)dh.THOIGIANTAO;
                    ws.Cells["A6"].Value = "THỜI GIAN ĐẶT";
                    ws.Cells["B6"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeDat);


                    ws.Cells["A7"].Value = "TÊN SẢN PHẨM";
                    ws.Cells["B7"].Value = "ĐƠN GIÁ";
                    ws.Cells["C7"].Value = "SỐ LƯỢNG";
                    ws.Cells["D7"].Value = "THÀNH TIỀN";

                    int rowStart = 8;
                    foreach (var item in lstCTDH)
                    {
                        ws.Row(rowStart).Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        ws.Row(rowStart).Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml(string.Format("white")));
                        ws.Cells[string.Format("A{0}", rowStart)].Value = item.SANPHAM.TENSANPHAM.ToString();
                        ws.Cells[string.Format("B{0}", rowStart)].Value = item.DONGIA;
                        ws.Cells[string.Format("C{0}", rowStart)].Value = item.SOLUONG;
                        ws.Cells[string.Format("D{0}", rowStart)].Value = item.THANHTIEN;
                        rowStart++;
                    }
                    ws.Cells[string.Format("C{0}", rowStart)].Value = "TỔNG TIỀN";
                    ws.Cells[string.Format("D{0}", rowStart)].Value = tongTien;
                    ws.Cells[string.Format("C{0}", rowStart + 1)].Value = "TIỀN KHUYẾN MÃI";
                    ws.Cells[string.Format("D{0}", rowStart + 1)].Value = khuyenMai;
                    ws.Cells[string.Format("C{0}", rowStart + 2)].Value = "THANH TOÁN";
                    ws.Cells[string.Format("D{0}", rowStart + 2)].Value = dh.TONGGIATRI;
                    ws.Cells["A:AZ"].AutoFitColumns();
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
                    Response.AddHeader("content-disposition", "attachment; filename=HoaDon" + id + ".xls");
                    Response.BinaryWrite(pck.GetAsByteArray());
                    Response.End();
                }
                else
                {
                    SetAlert("Lỗi: Không thể xuất đơn hàng!", "error");
                    return RedirectToAction("XemChiTietDon", "DonHang", new { id = id });
                }
                return View();
            }
            catch
            {
                return View();
            }
        }
    }
}