//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QLDienMay.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class DONHANG
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DONHANG()
        {
            this.CHITIETDONHANGs = new HashSet<CHITIETDONHANG>();
            this.PHIEUBAOHANHs = new HashSet<PHIEUBAOHANH>();
            this.PHIEUXUATs = new HashSet<PHIEUXUAT>();
        }
    
        public string MADONHANG { get; set; }
        public string NHANVIENPHUTRACH { get; set; }
        public string MAKHACHHANG { get; set; }
        public string MACUAHANG { get; set; }
        public System.DateTime THOIGIANTAO { get; set; }
        public string MAVOUCHER { get; set; }
        public string LOAI { get; set; }
        public string TINHTRANGXACNHAN { get; set; }
        public string TINHTRANGTHANHTOAN { get; set; }
        public string TINHTRANGGIAOHANG { get; set; }
        public Nullable<decimal> TONGGIATRI { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CHITIETDONHANG> CHITIETDONHANGs { get; set; }
        public virtual CUAHANG CUAHANG { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PHIEUBAOHANH> PHIEUBAOHANHs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PHIEUXUAT> PHIEUXUATs { get; set; }
        public virtual KHACHHANG KHACHHANG { get; set; }
        public virtual NHANVIEN NHANVIEN { get; set; }
        public virtual VOUCHER VOUCHER { get; set; }
    }
}
