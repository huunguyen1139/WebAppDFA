namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Drawing Code")]
    public partial class LIVE_ALLIANCE_90_Drawing_Code
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [Column("Drawing Code", Order = 0)]
        [StringLength(20)]
        public string Drawing_Code { get; set; }

        [Key]
        [Column("Version Code", Order = 1)]
        [StringLength(20)]
        public string Version_Code { get; set; }

       
        [StringLength(100)]
        public string Description { get; set; }

        [Column("Effected Date")]
        public DateTime Effected_Date { get; set; }

        
        [StringLength(250)]
        public string Revision { get; set; }

        public int Type { get; set; }

        [StringLength(200)]
        public string FilePath { get; set; }

        public DateTime FileLastModified { get; set; }
        
    }
}
