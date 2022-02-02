using OfficeOpenXml;
using PagedList;
using QLDienMay.Areas.Admin.Models;
using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class DoanhThuController : BaseController
    {
        QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1");
        // GET: Admin/DoanhThu
        public ActionResult Index(string from, string to, int page = 1, int pageSize = 30)
        {
            if (from != null && to != null && from != "" && to != "")
            {
                ViewBag.From = from;
                ViewBag.To = to;
                DateTime tuNgay = DateTime.Parse(from);
                DateTime denNgay = DateTime.Parse(to);
                List<CTDoanhThuNgay> lstDTN = GetCTDoanhThuNgay(from,to);
                return View(lstDTN.ToPagedList(page, pageSize));
            }
            else
            {
                List<CTDoanhThuNgay> lstDTN = GetCTDoanhThuNgay(null, null);
                return View(lstDTN.ToPagedList(page, pageSize));
            }
        }
        public ActionResult XuatDoanhThu(string from, string to)
        {
            try
            {
                NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
                DateTime tuNgay = DateTime.Parse(from);
                DateTime denNgay = DateTime.Parse(to);
                List<CTDoanhThuNgay> lst = GetCTDoanhThuNgay(from, to);

                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                from = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", tuNgay);
                to = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", denNgay);
                ExcelPackage pck = new ExcelPackage();
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add("DoanhThu");

                ws.Cells["B1"].Value = string.Format("BÁO CÁO DOANH THU");
                ws.Cells["B1"].Style.Font.Bold = true;

                ws.Cells["A2"].Value = "TỪ";
                ws.Cells["B2"].Value = from;

                ws.Cells["C2"].Value = "ĐẾN";
                ws.Cells["D2"].Value = to;

                ws.Cells["A3"].Value = "TÊN NHÂN VIÊN";
                ws.Cells["B3"].Value = nv.TENNHANVIEN;

                DateTime timeXuat = DateTime.Now;
                ws.Cells["C3"].Value = "Thời gian xuất";
                ws.Cells["D3"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeXuat);

                ws.Cells["A5"].Value = "THỜI GIAN";
                ws.Cells["A5"].Style.Font.Bold = true;
                ws.Cells["B5"].Value = "MÃ ĐƠN HÀNG";
                ws.Cells["B5"].Style.Font.Bold = true;
                ws.Cells["C5"].Value = "LOẠI HÓA ĐƠN";
                ws.Cells["C5"].Style.Font.Bold = true;
                ws.Cells["D5"].Value = "TỔNG TIỀN HÓA ĐƠN";
                ws.Cells["D5"].Style.Font.Bold = true;

                int rowStart = 6;
                foreach (var item in lst)
                {
                    ws.Cells[string.Format("A{0}", rowStart)].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", item.NgayGio);
                    ws.Cells[string.Format("B{0}", rowStart)].Value = item.MaDonHang;
                    ws.Cells[string.Format("C{0}", rowStart)].Value = item.Loai;
                    ws.Cells[string.Format("D{0}", rowStart)].Value =  item.TongTienHoaDon;
                    rowStart++;
                }
                ws.Cells[string.Format("C{0}", rowStart)].Value = "TỔNG DOANH THU";
                ws.Cells[string.Format("D{0}", rowStart)].Value = lst.Sum(x => x.TongTienHoaDon);
                ws.Cells["A:AZ"].AutoFitColumns();
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
                Response.AddHeader("content-disposition", "attachment; filename=BaoCaoDoanhThuTu " + from + " Den " + to + ".xls");
                Response.BinaryWrite(pck.GetAsByteArray());
                Response.End();
            }
            catch (Exception ex)
            {
                SetAlert("Lỗi: Xuất báo cáo thất bại, chưa tìm kiếm khoảng thời gian cần xuất!", "error");
            }
            return RedirectToAction("Index");
        }
        public List<CTDoanhThuNgay> GetCTDoanhThuNgay(string from, string to)
        {
            if (from == null && to == null)
            {
                List<CTDoanhThuNgay> lstDTN = new List<CTDoanhThuNgay>();
                DateTime today = new System.DateTime();
                int ngay = today.Day;
                int thang = today.Month;
                int nam = today.Year;
                List<DONHANG> lstDH = db.DONHANGs.Where(n => n.THOIGIANTAO.Day == ngay && n.THOIGIANTAO.Month == thang && n.THOIGIANTAO.Year == nam && n.TINHTRANGTHANHTOAN == "0" && n.TINHTRANGGIAOHANG == "0").ToList();
                foreach (var item in lstDH)
                {
                    CTDoanhThuNgay ctdt = new CTDoanhThuNgay();
                    ctdt.NgayGio = item.THOIGIANTAO;
                    ctdt.MaDonHang = item.MADONHANG;
                    if (item.LOAI == "0")
                        ctdt.Loai = "Online";
                    else
                        ctdt.Loai = "Offline";
                    ctdt.TongTienHoaDon = (decimal)item.TONGGIATRI;
                    lstDTN.Add(ctdt);
                }
                return lstDTN.OrderBy(n => n.NgayGio).ToList();
            }    
            else
            {
                DateTime tuNgay = DateTime.Parse(from);
                DateTime denNgay = DateTime.Parse(to);
                List<CTDoanhThuNgay> lstDTN = new List<CTDoanhThuNgay>();
                List<DONHANG> lstDH = db.DONHANGs.Where(n => n.THOIGIANTAO >= tuNgay && n.THOIGIANTAO <= denNgay && n.TINHTRANGTHANHTOAN == "0" && n.TINHTRANGGIAOHANG == "0").ToList();
                foreach (var item in lstDH)
                {
                    CTDoanhThuNgay ctdt = new CTDoanhThuNgay();
                    ctdt.NgayGio = item.THOIGIANTAO;
                    ctdt.MaDonHang = item.MADONHANG;
                    if (item.LOAI == "0")
                        ctdt.Loai = "Online";
                    else
                        ctdt.Loai = "Offline";
                    ctdt.TongTienHoaDon = (decimal)item.TONGGIATRI;
                    lstDTN.Add(ctdt);
                }
                return lstDTN.OrderBy(n => n.NgayGio).ToList();
            }
        }
        public List<CTDoanhThuNgay> GetCTDoanhThuNgay()
        {
            List<CTDoanhThuNgay> lstDTN = new List<CTDoanhThuNgay>();

            List<DONHANG> lstDH = db.DONHANGs.Where(n => n.TINHTRANGTHANHTOAN == "0" && n.TINHTRANGGIAOHANG == "0").ToList();
            foreach (var item in lstDH)
            {
                CTDoanhThuNgay ctdt = new CTDoanhThuNgay();
                ctdt.NgayGio = item.THOIGIANTAO;
                ctdt.MaDonHang = item.MADONHANG;
                if (item.LOAI == "0")
                    ctdt.Loai = "Online";
                else
                    ctdt.Loai = "Offline";
                ctdt.TongTienHoaDon = (decimal)item.TONGGIATRI;
                lstDTN.Add(ctdt);
            }
            return lstDTN.OrderBy(n => n.NgayGio).ToList();
        }
        public List<DoanhThuThang> GetDoanhThuNam(int id)
        {
            List<CTDoanhThuNgay> lstDTN = GetCTDoanhThuNgay();
            lstDTN = lstDTN.Where(x => x.NgayGio.Year == id).OrderBy(x => x.NgayGio).ToList();
            List<DoanhThuThang> lstDTT = new List<DoanhThuThang>();
            for (int i = 1; i <= 12; i++)
            {
                DoanhThuThang dtt = new DoanhThuThang();
                dtt.Thang = "Tháng " + i.ToString();
                dtt.TongDoanhThu = lstDTN.Where(x => x.NgayGio.Month == i).Sum(x => x.TongTienHoaDon);
                lstDTT.Add(dtt);
            }
            return lstDTT.ToList();
        }
        public ActionResult Graph(int id)
        {
            try
            {
                if (id != null)
                {
                    List<DoanhThuThang> list = GetDoanhThuNam(id);
                    var thang = list.Select(x => x.Thang).Distinct();
                    ViewBag.Thang = thang;
                    ViewBag.DoanhThu = list.Select(x => x.TongDoanhThu);
                }
                else
                {
                    id = DateTime.Now.Year;
                    List<DoanhThuThang> list = GetDoanhThuNam(id);
                    var thang = list.Select(x => x.Thang).Distinct();
                    ViewBag.Thang = thang;
                    ViewBag.DoanhThu = list.Select(x => x.TongDoanhThu);
                }
                ViewBag.NamXuat = id;
                return View();
            }
            catch (Exception ex)
            {
                return View(2021);
            }
        }
        public List<DoanhThuNgay> GetDoanhThuThang(int thang, int nam)
        {
            List<CTDoanhThuNgay> lstDTT = GetCTDoanhThuNgay();
            lstDTT = lstDTT.Where(x => x.NgayGio.Year == nam && x.NgayGio.Month == thang).OrderBy(x => x.NgayGio).ToList();
            List<DoanhThuNgay> lstDTN = new List<DoanhThuNgay>();
            int n;
            if (thang == 1 || thang == 3 || thang == 5 || thang == 7 || thang == 8 || thang == 10 || thang == 12)
                n = 31;
            else if (thang == 4 || thang == 6 || thang == 9 || thang == 11)
            {
                n = 30;
            }
            else
                n = 29;
            for (int i = 1; i <= n; i++)
            {
                DoanhThuNgay dtn = new DoanhThuNgay();
                dtn.Ngay = "Ngày " + i.ToString();
                dtn.TongDoanhThu = lstDTT.Where(x => x.NgayGio.Day == i && x.NgayGio.Month == thang && x.NgayGio.Year == nam).Sum(x => x.TongTienHoaDon);
                lstDTN.Add(dtn);
            }
            return lstDTN.ToList();
        }
        public ActionResult GraphTheoThang(int thang, int nam)
        {
            try
            {
                if (thang != null && nam != null)
                {
                    List<DoanhThuNgay> list = GetDoanhThuThang(thang, nam);
                    var ngay = list.Select(x => x.Ngay).Distinct();
                    ViewBag.Ngay = ngay;
                    ViewBag.DoanhThu = list.Select(x => x.TongDoanhThu);
                }
                else
                {
                    thang = DateTime.Now.Month;
                    nam = DateTime.Now.Year;
                    List<DoanhThuNgay> list = GetDoanhThuThang(thang, nam);
                    var ngay = list.Select(x => x.Ngay).Distinct();
                    ViewBag.Ngay = ngay;
                    ViewBag.DoanhThu = list.Select(x => x.TongDoanhThu);
                }
                ViewBag.ThangXuat = thang;
                ViewBag.NamXuat = nam;
                return View();
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        public ActionResult XuatBaoCaoDoanhThuThang(int thang, int nam)
        {
            NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
            List<DoanhThuNgay> lstDTN = GetDoanhThuThang(thang, nam);

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            ExcelPackage pck = new ExcelPackage();
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Thang " + thang + " Nam " + nam);

            ws.Cells["B1"].Value = string.Format("BÁO CÁO DOANH THU THÁNG {0} NĂM {1}", thang, nam);
            ws.Cells["B1"].Style.Font.Bold = true;
            ws.Cells["B1"].Style.Font.Size = 18;

            ws.Cells["A2"].Value = "TÊN NHÂN VIÊN";
            ws.Cells["B2"].Value = nv.TENNHANVIEN;


            DateTime timeXuat = DateTime.Now;
            ws.Cells["C2"].Value = "Thời gian xuất";
            ws.Cells["D2"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeXuat);

            ws.Cells["A4"].Value = "NGÀY";
            ws.Cells["A4"].Style.Font.Bold = true;
            ws.Cells["B4"].Value = "TỔNG DOANH THU";
            ws.Cells["B4"].Style.Font.Bold = true;

            int rowStart = 5;
            foreach (var item in lstDTN)
            {
                ws.Cells[string.Format("A{0}", rowStart)].Value = item.Ngay;
                ws.Cells[string.Format("B{0}", rowStart)].Value = item.TongDoanhThu;
                rowStart++;
            }
            ws.Cells[string.Format("A{0}", rowStart)].Value = "TỔNG DOANH THU THÁNG";
            ws.Cells[string.Format("B{0}", rowStart)].Value = lstDTN.Sum(x => x.TongDoanhThu);
            ws.Cells["A:AZ"].AutoFitColumns();
            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
            Response.AddHeader("content-disposition", "attachment; filename=BaoCaoDoanhThuThang" + thang + "Nam" + nam + ".xls");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
            return View();
        }
        public ActionResult XuatBaoCaoDoanhThuNam(int nam)
        {
            NHANVIEN nv = Session["NhanVien"] as NHANVIEN;
            List<DoanhThuThang> lstDTT = GetDoanhThuNam(nam);

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            ExcelPackage pck = new ExcelPackage();
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Nam " + nam);

            ws.Cells["B1"].Value = string.Format("BÁO CÁO DOANH THU NĂM {0}", nam);
            ws.Cells["B1"].Style.Font.Bold = true;

            ws.Cells["A2"].Value = "TÊN NHÂN VIÊN";
            ws.Cells["B2"].Value = nv.TENNHANVIEN;

            DateTime timeXuat = DateTime.Now;
            ws.Cells["C2"].Value = "Thời gian xuất";
            ws.Cells["D2"].Value = string.Format("{0:dd/MM/yyyy} vào lúc {0:H: mm tt}", timeXuat);

            ws.Cells["A4"].Value = "THÁNG";
            ws.Cells["A4"].Style.Font.Bold = true;
            ws.Cells["B4"].Value = "TỔNG DOANH THU";
            ws.Cells["B4"].Style.Font.Bold = true;

            int rowStart = 5;
            foreach (var item in lstDTT)
            {
                ws.Cells[string.Format("A{0}", rowStart)].Value = item.Thang;
                ws.Cells[string.Format("B{0}", rowStart)].Value = item.TongDoanhThu;
                rowStart++;
            }
            ws.Cells[string.Format("A{0}", rowStart)].Value = "TỔNG DOANH THU NĂM";
            ws.Cells[string.Format("B{0}", rowStart)].Value = lstDTT.Sum(x => x.TongDoanhThu);
            ws.Cells["A:AZ"].AutoFitColumns();
            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetxml.sheet";
            Response.AddHeader("content-disposition", "attachment; filename=BaoCaoDoanhThuNam" + nam + ".xls");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
            return View();
        }
        public Ratio GetLoai(int id)
        {
            List<CTDoanhThuNgay> lstDTN = GetCTDoanhThuNgay();
            int onl = lstDTN.Where(x => x.NgayGio.Year == id).Count(x => x.Loai == "Online");
            int off = lstDTN.Where(x => x.NgayGio.Year == id).Count(x => x.Loai == "Offline");
            Ratio rat = new Ratio();
            rat.Online = onl;
            rat.Offline = off;
            return rat;
        }
        public ActionResult PieChart(int id)
        {
            try
            {
                if (id != null)
                {
                    ViewBag.Loai = GetLoai(id);
                    ViewBag.Nam = id;
                }
                else
                {
                    id = DateTime.Now.Year;
                    ViewBag.Loai = GetLoai(id);
                    ViewBag.Nam = id;
                }
                return View();
            }
            catch (Exception ex)
            {
                return View(2021);
            }
        }
    }
}