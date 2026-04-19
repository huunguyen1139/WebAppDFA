namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Leg Finish")]
    public partial class LIVE_ALLIANCE_90_Leg_Finish
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [StringLength(20)]
        public string Code { get; set; }

       
        [StringLength(100)]
        public string Description { get; set; }
    }
}
