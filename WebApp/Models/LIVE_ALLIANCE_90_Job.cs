namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Job")]
    public partial class LIVE_ALLIANCE_90_Job
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [StringLength(20)]
        public string No_ { get; set; }

        [Column("Search Description")]        
        [StringLength(50)]
        public string Search_Description { get; set; }

        
        [StringLength(50)]
        public string Description { get; set; }

        [Column("Description 2")]        
        [StringLength(50)]
        public string Description_2 { get; set; }

        [Column("Bill-to Customer No_")]        
        [StringLength(20)]
        public string Bill_to_Customer_No_ { get; set; }

        [Column("Creation Date")]
        public DateTime Creation_Date { get; set; }

        [Column("Starting Date")]
        public DateTime Starting_Date { get; set; }

        [Column("Ending Date")]
        public DateTime Ending_Date { get; set; }

        public int Status { get; set; }

        [Column("Person Responsible")]        
        [StringLength(20)]
        public string Person_Responsible { get; set; }

        [Column("Global Dimension 1 Code")]        
        [StringLength(20)]
        public string Global_Dimension_1_Code { get; set; }

        [Column("Global Dimension 2 Code")]        
        [StringLength(20)]
        public string Global_Dimension_2_Code { get; set; }

        [Column("Job Posting Group")]        
        [StringLength(10)]
        public string Job_Posting_Group { get; set; }

        public int Blocked { get; set; }

        [Column("Last Date Modified")]
        public DateTime Last_Date_Modified { get; set; }

        [Column("Customer Disc_ Group")]        
        [StringLength(20)]
        public string Customer_Disc__Group { get; set; }

        [Column("Customer Price Group")]        
        [StringLength(10)]
        public string Customer_Price_Group { get; set; }

        [Column("Language Code")]        
        [StringLength(10)]
        public string Language_Code { get; set; }

        [Column(TypeName = "image")]
        public byte[] Picture { get; set; }

        [Column("Bill-to Name")]       
        [StringLength(50)]
        public string Bill_to_Name { get; set; }

        [Column("Bill-to Address")]       
        [StringLength(50)]
        public string Bill_to_Address { get; set; }

        [Column("Bill-to Address 2")]       
        [StringLength(50)]
        public string Bill_to_Address_2 { get; set; }

        [Column("Bill-to City")]       
        [StringLength(30)]
        public string Bill_to_City { get; set; }

        [Column("Bill-to County")]      
        [StringLength(30)]
        public string Bill_to_County { get; set; }

        [Column("Bill-to Post Code")]       
        [StringLength(20)]
        public string Bill_to_Post_Code { get; set; }

        [Column("No_ Series")]       
        [StringLength(10)]
        public string No__Series { get; set; }

        [Column("Bill-to Country_Region Code")]       
        [StringLength(10)]
        public string Bill_to_Country_Region_Code { get; set; }

        [Column("Bill-to Name 2")]        
        [StringLength(50)]
        public string Bill_to_Name_2 { get; set; }

        public int Reserve { get; set; }

        [Column("WIP Method")]       
        [StringLength(20)]
        public string WIP_Method { get; set; }

        [Column("Currency Code")]       
        [StringLength(10)]
        public string Currency_Code { get; set; }

        [Column("Bill-to Contact No_")]       
        [StringLength(20)]
        public string Bill_to_Contact_No_ { get; set; }

        [Column("Bill-to Contact")]       
        [StringLength(50)]
        public string Bill_to_Contact { get; set; }

        [Column("WIP Posting Date")]
        public DateTime WIP_Posting_Date { get; set; }

        [Column("Invoice Currency Code")]       
        [StringLength(10)]
        public string Invoice_Currency_Code { get; set; }

        [Column("Exch_ Calculation (Cost)")]
        public int Exch__Calculation__Cost_ { get; set; }

        [Column("Exch_ Calculation (Price)")]
        public int Exch__Calculation__Price_ { get; set; }

        [Column("Allow Schedule_Contract Lines")]
        public byte Allow_Schedule_Contract_Lines { get; set; }

        public byte Complete { get; set; }

        [Column("Apply Usage Link")]
        public byte Apply_Usage_Link { get; set; }

        [Column("WIP Posting Method")]
        public int WIP_Posting_Method { get; set; }

        public string OrderClass { get; set; }

        [StringLength(50)]
        public string LastUpdatedUser { get; set; }

        public DateTime LastUpdatedDate { get; set; }
    }
}
