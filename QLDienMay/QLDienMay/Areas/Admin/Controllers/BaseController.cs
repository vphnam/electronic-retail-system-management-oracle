using QLDienMay.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QLDienMay.Areas.Admin.Controllers
{
    public class BaseController : Controller
    {
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            NHANVIEN session = Session["NhanVien"] as NHANVIEN;
            string actionName = filterContext.ActionDescriptor.ActionName;
            string controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
            if (session == null)
            {
                if(actionName != "DangNhap")
                {
                    filterContext.Result = new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary(new { controller = "PhienTruyCap", action = "DangNhap", area = "Admin" }));
                }
            }
            else
            {
                using (QLDienMayEntities db = new QLDienMayEntities("name=QLDienMayEntities1"))
                { 
                    ObjectParameter return_value = new ObjectParameter("rETURN_VALUE", typeof(int));
                    db.PROC_KIEM_TRA_QUYEN(session.MANHANVIEN, actionName, controllerName, return_value);
                    int kq = int.Parse(string.Format("{0}", return_value.Value));
                    if (kq == -1)
                    {
                        filterContext.Result = new RedirectToRouteResult(new System.Web.Routing.RouteValueDictionary(new { controller = "PhienTruyCap", action = "KhongTheTruyCap", area = "Admin" }));
                    }
                }   
            }
            base.OnActionExecuting(filterContext);
        }

        protected void SetAlert(string message, string type)
        {
            TempData["AlertMessage"] = message;
            if (type == "success")
            {
                TempData["AlertType"] = "alert-success";
            }
            else if (type == "warning")
            {
                TempData["AlertType"] = "alert-warning";
            }
            else if (type == "error")
            {
                TempData["AlertType"] = "alert-danger";
            }
        }
        
    }
}