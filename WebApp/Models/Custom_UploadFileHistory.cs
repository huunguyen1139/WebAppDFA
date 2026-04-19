namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Custom_UploadFileHistory
    {
        [Key]
        public int RowIndex { get; set; }

        [Required]
        [StringLength(20)]
        public string Type { get; set; }

        [Required]
        [StringLength(20)]
        public string Code { get; set; }

        [Required]
        [StringLength(20)]
        public string Version { get; set; }

        [Required]
        [StringLength(200)]
        public string FileName { get; set; }

        [Required]
        [StringLength(200)]
        public string FilePath { get; set; }

        public DateTime FileLastModified { get; set; }

        public DateTime UploadDate { get; set; }

        [Required]
        [StringLength(50)]
        public string UploadUser { get; set; }
    }
}
