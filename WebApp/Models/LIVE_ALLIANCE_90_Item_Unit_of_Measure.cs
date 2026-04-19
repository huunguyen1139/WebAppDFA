namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Item Unit of Measure")]
    public partial class LIVE_ALLIANCE_90_Item_Unit_of_Measure
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [Column("Item No_", Order = 0)]
        [StringLength(20)]
        public string Item_No_ { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(10)]
        public string Code { get; set; }

        [Column("Qty_ per Unit of Measure")]
        public decimal Qty__per_Unit_of_Measure { get; set; }

        public decimal Length { get; set; }

        public decimal Width { get; set; }

        public decimal Height { get; set; }

        public decimal Cubage { get; set; }

        public decimal Weight { get; set; }

        [Column("Cubage 2")]
        public decimal Cubage_2 { get; set; }

       
        [StringLength(20)]
        public string Packing { get; set; }
    }
}
