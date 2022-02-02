using OfficeOpenXml;
using PagedList;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Excel = Microsoft.Office.Interop.Excel;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class KhoController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/Kho
        public ActionResult Index(string id, int page = 1, int pageSize = 30)
        {
            string maNv = (string)Session["MaNhanVien"];
            string quyen = (string)Session["Quyen"];
            if(quyen == "CV001")
            {
                if (id != null && id != "")
                {
                    return View(db.KHOes.Where(n => n.MAKHO.StartsWith(id)).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
                }
                else
                    return View(db.KHOes.ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
            }
            else
            {
                if (id != null && id != "")
                {
                    return View(db.KHOes.Where(n => n.MAKHO.StartsWith(id) && n.TRUONGKHO == maNv).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
                }
                else
                    return View(db.KHOes.Where(n => n.TRUONGKHO == maNv).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
            }        
        }
        public ActionResult ChiTietKho(string id, string idSanPham, int page = 1, int pageSize = 30)
        {
            string maNv = (string)Session["MaNhanVien"];
            KHO kho = db.KHOes.FirstOrDefault(n => n.TRUONGKHO == maNv);
            string quyen = (string)Session["Quyen"];
            if (quyen == "CV001")
            {
                if (idSanPham != null && idSanPham != "")
                {
                    return View(db.CHITIETKHOes.Where(n => n.MAKHO == id && n.MASANPHAM.StartsWith(idSanPham)).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
                }
                else
                    return View(db.CHITIETKHOes.Where(n => n.MAKHO == id).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
            }   
            else if (id != kho.MAKHO)
            {
                SetAlert("Người dùng không có quyền truy cập vào kho này!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }  
            else
            {
                if (idSanPham != null && idSanPham != "")
                {
                    return View(db.CHITIETKHOes.Where(n => n.MAKHO == kho.MAKHO && n.MASANPHAM.StartsWith(idSanPham)).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
                }
                else
                    return View(db.CHITIETKHOes.Where(n => n.MAKHO == kho.MAKHO).ToList().OrderBy(n => n.MAKHO).ToPagedList(page, pageSize));
            }       
        }
        public ActionResult PhieuNhap(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];
                KHO kho = db.KHOes.FirstOrDefault(n => n.TRUONGKHO == maNv);
                string quyen = (string)Session["Quyen"];
                if (quyen == "CV001")
                    return View(db.PHIEUNHAPs.ToList().OrderBy(n => n.MAPHIEUNHAP).ToPagedList(page, pageSize));
                else if (kho == null)
                {
                    SetAlert("Người dùng không có quyền truy cập!", "error");
                    return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
                }
                else
                    return View(db.PHIEUNHAPs.Where(n => n.MAKHO == kho.MAKHO).ToList().OrderBy(n => n.MAPHIEUNHAP).ToPagedList(page, pageSize));
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập vào đường dẫn!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult ChiTietPhieuNhap(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                ViewBag.MaPhieuNhap = id;
                string quyen = (string)Session["Quyen"];
                PHIEUNHAP pn = db.PHIEUNHAPs.SingleOrDefault(n => n.MAPHIEUNHAP == id);
                string maNv = (string)Session["MaNhanVien"];
                KHO kho = db.KHOes.FirstOrDefault(n => n.TRUONGKHO == maNv);
                if (quyen == "CV001")
                {
                    return View(db.CHITIETPHIEUNHAPs.Where(n => n.MAPHIEUNHAP == id).ToList().OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
                }
                else if (kho == null || pn == null || kho.MAKHO != pn.MAKHO)
                {
                    SetAlert("Người dùng không có quyền truy cập!", "error");
                    return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
                }
                else
                    return View(db.CHITIETPHIEUNHAPs.Where(n => n.MAPHIEUNHAP == id).ToList().OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập vào đường dẫn!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        [HttpPost]
        public ActionResult ImportPhieuNhap(HttpPostedFileBase excelFile)
        {
            try
            {
                if (excelFile.ContentLength == 0)
                {
                    SetAlert("Vui lòng chọn file", "error");
                    return RedirectToAction("PhieuNhap");
                }
                else
                {
                    if (excelFile.FileName.EndsWith("xls") || excelFile.FileName.EndsWith("xlsx"))
                    {
                        string fileName = Path.GetFileName(excelFile.FileName);
                        string path = Path.Combine(Server.MapPath("~/Content"), fileName);
                        if (System.IO.File.Exists(path))
                        {
                            SetAlert("Lỗi: File đã được thêm vào, vui lòng đổi tên file", "error");
                        }
                        excelFile.SaveAs(path);
                        ///read data
                        Excel.Application application = new Excel.Application();
                        Excel.Workbook workBook = application.Workbooks.Open(path);
                        Excel.Worksheet workSheet = workBook.ActiveSheet;
                        Excel.Range range = workSheet.UsedRange;

                        string maNCC = ((Excel.Range)range.Cells[4, 2]).Text;
                        string nhanVienPhuTrach = ((Excel.Range)range.Cells[4, 4]).Text;
                        string maKho = ((Excel.Range)range.Cells[5, 2]).Text;
                        decimal tongGiaTri = decimal.Parse(((Excel.Range)range.Cells[6, 2]).Text);
                        List<CHITIETPHIEUNHAP> lstCTPN = new List<CHITIETPHIEUNHAP>();
                        bool flag = true;
                        for (int row = 9; row <  range.Rows.Count + 1; row++)
                        {
                            CHITIETPHIEUNHAP ctpn = new CHITIETPHIEUNHAP();
                            ctpn.MASANPHAM = ((Excel.Range)range.Cells[row, 1]).Text;
                            SANPHAM sp = db.SANPHAMs.Find(ctpn.MASANPHAM);
                            if (sp == null)
                            {
                                flag = false;
                                break;
                            }
                            ctpn.SOLUONG = Int32.Parse(((Excel.Range)range.Cells[row, 2]).Text);
                            ctpn.DONGIANHAP = decimal.Parse(((Excel.Range)range.Cells[row, 3]).Text);
                            lstCTPN.Add(ctpn);
                        }
                        if (flag == false)
                        {
                            SetAlert("File không đúng định dạng mẫu", "error");
                            return RedirectToAction("PhieuNhap");
                        }
                        else
                        {
                            if(tongGiaTri != lstCTPN.Sum(n => n.SOLUONG * n.DONGIANHAP))
                            {
                                SetAlert("File không đúng định dạng, tổng tiền không trùng khớp", "error");
                                return RedirectToAction("PhieuNhap");
                            }
                            else
                            {
                                ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                                ObjectParameter return_id = new ObjectParameter("mA_PN", typeof(string));
                                db.PROC_INSERT_PHIEU_NHAP(maNCC, nhanVienPhuTrach, maKho, tongGiaTri, return_id, return_value);
                                string maPN = return_id.Value.ToString().Trim();
                                int kq = int.Parse(string.Format("{0}", return_value.Value));
                                if (kq == 1)
                                {
                                    SetAlert("File không đúng định dạng mẫu, lỗi nhà cung cấp", "error");
                                    return RedirectToAction("PhieuNhap");
                                }
                                else if (kq == 2)
                                {
                                    SetAlert("File không đúng định dạng mẫu, lỗi mã nhân viên", "error");
                                    return RedirectToAction("PhieuNhap");
                                }
                                else if (kq == 3)
                                {
                                    SetAlert("File không đúng định dạng mẫu, lỗi mã nhân viên", "error");
                                    return RedirectToAction("PhieuNhap");
                                }
                                else if (kq == 4)
                                {
                                    SetAlert("File không đúng định dạng mẫu, lỗi mã nhân viên và mã kho", "error");
                                    return RedirectToAction("PhieuNhap");
                                }
                                else if (kq == -1)
                                {
                                    SetAlert("File không đúng định dạng", "error");
                                    return RedirectToAction("PhieuNhap");
                                }
                                else
                                {
                                    foreach (var item in lstCTPN)
                                    {
                                        ObjectParameter return_value2 = new ObjectParameter("rETURN_VALUE", typeof(int));
                                        db.PROC_INSERT_CHITIET_PHIEU_NHAP(maPN, item.MASANPHAM, item.SOLUONG, item.DONGIANHAP, return_value2);
                                        int kq2 = int.Parse(string.Format("{0}", return_value2.Value));
                                    }
                                    SetAlert("Thêm phiếu nhập vào cơ sở dữ liệu thành công", "success");
                                    return RedirectToAction("PhieuNhap");
                                }
                            }
                        }
                    }
                    else
                    {
                        SetAlert("File đã chọn không đúng định dạng excel", "error");
                        return RedirectToAction("PhieuNhap");
                    }
                }
            }
            catch
            {
                SetAlert("Lỗi: File không đúng định dạng mẫu", "error");
                return RedirectToAction("PhieuNhap");
            }
        }


        public ActionResult PhieuXuat(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                string maNv = (string)Session["MaNhanVien"];
                KHO kho = db.KHOes.FirstOrDefault(n => n.TRUONGKHO == maNv);
                string quyen = (string)Session["Quyen"];
                if (quyen == "CV001")
                    return View(db.PHIEUXUATs.ToList().OrderBy(n => n.MAPHIEUXUAT).ToPagedList(page, pageSize));
                else if (kho == null)
                {
                    SetAlert("Người dùng không có quyền truy cập!", "error");
                    return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
                }
                else
                    return View(db.PHIEUXUATs.Where(n => n.MAKHO == kho.MAKHO).ToList().OrderBy(n => n.MAPHIEUXUAT).ToPagedList(page, pageSize));
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập vào trang!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult ChiTietPhieuXuat(string id, int page = 1, int pageSize = 30)
        {
            try
            {
                ViewBag.MaPhieuXuat = id;
                PHIEUXUAT px = db.PHIEUXUATs.SingleOrDefault(n => n.MAPHIEUXUAT == id);
                string maNv = (string)Session["MaNhanVien"];
                KHO kho = db.KHOes.FirstOrDefault(n => n.TRUONGKHO == maNv);
                string quyen = (string)Session["Quyen"];
                if (quyen == "CV001")
                    return View(db.CHITIETPHIEUXUATs.Where(n => n.MAPHIEUXUAT == id).ToList().OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
                else if (kho == null || px == null || kho.MAKHO != px.MAKHO)
                {
                    SetAlert("Người dùng không có quyền truy cập!", "error");
                    return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
                }
                else
                    return View(db.CHITIETPHIEUXUATs.Where(n => n.MAPHIEUXUAT == id).ToList().OrderBy(n => n.MASANPHAM).ToPagedList(page, pageSize));
            }
            catch
            {
                SetAlert("Lỗi: Không thể truy cập vào trang!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult XuatPhieuNhap(string id)
        {
            try
            {
                PHIEUNHAP pn = db.PHIEUNHAPs.Find(id);
                if (pn != null)
                {
                    List<CHITIETPHIEUNHAP> lstCTPX = db.CHITIETPHIEUNHAPs.Where(n => n.MAPHIEUNHAP == id).ToList();
                    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                    ExcelPackage pck = new ExcelPackage();
                    ExcelWorksheet ws = pck.Workbook.Worksheets.Add("PhieuNhap");

                    ws.Cells["B2"].Value = "PHIẾU NHẬP";

                    ws.Cells["A4"].Value = "MÃ PHIẾU NHẬP";
                    ws.Cells["B4"].Value = id;



                    ws.Cells["C4"].Value = "TÊN NHÀ CUNG CẤP";
                    ws.Cells["D4"].Value = pn.NHACUNGCAP1.TENNCC;

                    NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
                    ws.Cells["A5"].Value = "NHÂN VIÊN PHỤ TRÁCH";
                    ws.Cells["B5"].Value = pn.NHANVIEN.TENNHANVIEN;

                    ws.Cells["C5"].Value = "KHO";
                    ws.Cells["D5"].Value = pn.KHO.DIACHI.ToString();

                    ws.Cells["A6"].Value = "NHÂN VIÊN XUẤT PHIẾU";
                    ws.Cells["B6"].Value = nv.TENNHANVIEN.ToString();

                    DateTime timeTao = (DateTime)pn.THOIGIANTAO;
                    ws.Cells["A7"].Value = "THỜI GIAN TẠO";
                    ws.Cells["B7"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeTao);

                    ws.Cells["A8"].Value = "TỔNG GIÁ TRỊ";
                    ws.Cells["B8"].Value = pn.TONGGIATRI.ToString();

                    ws.Cells["A9"].Value = "TÊN SẢN PHẨM";
                    ws.Cells["B9"].Value = "SỐ LƯỢNG";
                    ws.Cells["C9"].Value = "ĐƠN GIÁ NHẬP";

                    int rowStart = 10;
                    foreach (var item in lstCTPX)
                    {
                        ws.Row(rowStart).Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        ws.Row(rowStart).Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml(string.Format("white")));
                        ws.Cells[string.Format("A{0}", rowStart)].Value = item.SANPHAM.TENSANPHAM.ToString();
                        ws.Cells[string.Format("B{0}", rowStart)].Value = item.SOLUONG;
                        ws.Cells[string.Format("C{0}", rowStart)].Value = item.DONGIANHAP;
                        rowStart++;
                    }
                    ws.Cells["A:AZ"].AutoFitColumns();
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
                    Response.AddHeader("content-disposition", "attachment; filename=PhieuXuat" + id + ".xls");
                    Response.BinaryWrite(pck.GetAsByteArray());
                    Response.End();
                }
                else
                {
                    SetAlert("Lỗi: Không thể xuất phiếu nhập!", "error");
                    return RedirectToAction("ChiTietPhieuXuat", "Kho", new { id = id });
                }
                return View();
            }
            catch
            {
                SetAlert("Lỗi: Có lỗi xảy ra trong quá trình, vui lòng kiểm tra lại thông tin!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
        public ActionResult XuatPhieuXuat(string id)
        {
            try
            {
                PHIEUXUAT px = db.PHIEUXUATs.Find(id);
                if (px != null)
                {
                    List<CHITIETPHIEUXUAT> lstCTPX = db.CHITIETPHIEUXUATs.Where(n => n.MAPHIEUXUAT == id).ToList();
                    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                    ExcelPackage pck = new ExcelPackage();
                    ExcelWorksheet ws = pck.Workbook.Worksheets.Add("PhieuXuat");

                    ws.Cells["B2"].Value = "PHIẾU XUẤT";

                    ws.Cells["A4"].Value = "MÃ PHIẾU XUẤT";
                    ws.Cells["B4"].Value = id;


                    NHANVIEN nv = db.NHANVIENs.Find(px.NHANVIENTAOPHIEU);
                    ws.Cells["C4"].Value = "NHÂN VIÊN TẠO PHIẾU";
                    ws.Cells["D4"].Value = nv.TENNHANVIEN.ToString();


                    ws.Cells["A5"].Value = "TRƯỞNG KHO";
                    ws.Cells["B5"].Value = px.NHANVIEN1.TENNHANVIEN.ToString();

                    ws.Cells["C5"].Value = "KHO";
                    ws.Cells["D5"].Value = px.KHO.DIACHI.ToString();

                    ws.Cells["A6"].Value = "ĐƠN HÀNG";
                    ws.Cells["B6"].Value = px.MADONHANG.ToString();

                    DateTime timeDat = (DateTime)px.THOIGIANTAO;
                    ws.Cells["C6"].Value = "THỜI GIAN TẠO";
                    ws.Cells["D6"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeDat);

                    ws.Cells["A7"].Value = "TỔNG GIÁ TRỊ";
                    ws.Cells["B7"].Value = px.TONGGIATRI.ToString();

                    ws.Cells["A8"].Value = "TÊN SẢN PHẨM";
                    ws.Cells["B8"].Value = "SỐ LƯỢNG";

                    int rowStart = 9;
                    foreach (var item in lstCTPX)
                    {
                        ws.Row(rowStart).Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        ws.Row(rowStart).Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml(string.Format("white")));
                        ws.Cells[string.Format("A{0}", rowStart)].Value = item.SANPHAM.TENSANPHAM.ToString();
                        ws.Cells[string.Format("B{0}", rowStart)].Value = item.SOLUONG;
                        rowStart++;
                    }
                    ws.Cells["A:AZ"].AutoFitColumns();
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
                    Response.AddHeader("content-disposition", "attachment; filename=PhieuXuat" + id + ".xls");
                    Response.BinaryWrite(pck.GetAsByteArray());
                    Response.End();
                }
                else
                {
                    SetAlert("Lỗi: Không thể xuất phiếu xuất!", "error");
                    return RedirectToAction("ChiTietPhieuXuat", "Kho", new { id = id });
                }
                return View();
            }
            catch
            {
                SetAlert("Lỗi: Có lỗi xảy ra trong quá trình, vui lòng kiểm tra lại thông tin!", "error");
                return RedirectToAction("KhongTheTruyCap", "PhienTruyCap");
            }
        }
    }
}