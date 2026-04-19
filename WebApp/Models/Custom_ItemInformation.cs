namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Custom_ItemInformation
    {
        [Key]
        [StringLength(20)]
        public string ItemCode { get; set; }


        [StringLength(1000)]
        public string FullRemark { get; set; }


        [StringLength(1000)]
        public string FullName { get; set; }

        [StringLength(1000)]
        public string SiteOrderDescription { get; set; }

        [StringLength(20)]
        public string DrawingCode { get; set; }


        [StringLength(20)]
        public string DrawingVersionCode { get; set; }

        [StringLength(500)]
        public string DrawingNote { get; set; }
    }
}
