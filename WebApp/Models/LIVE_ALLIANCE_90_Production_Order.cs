namespace PIMS.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LIVE_ALLIANCE_90$Production Order")]
    public partial class LIVE_ALLIANCE_90_Production_Order
    {
        [Column(TypeName = "timestamp")]
        [MaxLength(8)]
        [Timestamp]
        public byte[] timestamp { get; set; }

        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Status { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(20)]
        public string No_ { get; set; }

        
        [StringLength(50)]
        public string Description { get; set; }

        [Column("Search Description")]
        
        [StringLength(50)]
        public string Search_Description { get; set; }

        [Column("Description 2")]
        
        [StringLength(50)]
        public string Description_2 { get; set; }

        [Column("Creation Date")]
        public DateTime Creation_Date { get; set; }

        [Column("Last Date Modified")]
        public DateTime Last_Date_Modified { get; set; }

        [Column("Source Type")]
        public int Source_Type { get; set; }

        [Column("Source No_")]
        
        [StringLength(20)]
        public string Source_No_ { get; set; }

        [Column("Routing No_")]
        
        [StringLength(20)]
        public string Routing_No_ { get; set; }

        [Column("Inventory Posting Group")]
        
        [StringLength(10)]
        public string Inventory_Posting_Group { get; set; }

        [Column("Gen_ Prod_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Prod__Posting_Group { get; set; }

        [Column("Gen_ Bus_ Posting Group")]
        
        [StringLength(10)]
        public string Gen__Bus__Posting_Group { get; set; }

        [Column("Starting Time")]
        public DateTime Starting_Time { get; set; }

        [Column("Starting Date")]
        public DateTime Starting_Date { get; set; }

        [Column("Ending Time")]
        public DateTime Ending_Time { get; set; }

        [Column("Ending Date")]
        public DateTime Ending_Date { get; set; }

        [Column("Due Date")]
        public DateTime Due_Date { get; set; }

        [Column("Finished Date")]
        public DateTime Finished_Date { get; set; }

        public byte Blocked { get; set; }

        [Column("Shortcut Dimension 1 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_1_Code { get; set; }

        [Column("Shortcut Dimension 2 Code")]
        
        [StringLength(20)]
        public string Shortcut_Dimension_2_Code { get; set; }

        [Column("Location Code")]
        
        [StringLength(10)]
        public string Location_Code { get; set; }

        [Column("Bin Code")]
        
        [StringLength(20)]
        public string Bin_Code { get; set; }

        [Column("Replan Ref_ No_")]
        
        [StringLength(20)]
        public string Replan_Ref__No_ { get; set; }

        [Column("Replan Ref_ Status")]
        public int Replan_Ref__Status { get; set; }

        [Column("Low-Level Code")]
        public int Low_Level_Code { get; set; }

        public decimal Quantity { get; set; }

        [Column("Unit Cost")]
        public decimal Unit_Cost { get; set; }

        [Column("Cost Amount")]
        public decimal Cost_Amount { get; set; }

        [Column("No_ Series")]
        
        [StringLength(10)]
        public string No__Series { get; set; }

        [Column("Planned Order No_")]
        
        [StringLength(20)]
        public string Planned_Order_No_ { get; set; }

        [Column("Firm Planned Order No_")]
        
        [StringLength(20)]
        public string Firm_Planned_Order_No_ { get; set; }

        [Column("Simulated Order No_")]
        
        [StringLength(30)]
        public string Simulated_Order_No_ { get; set; }

        [Column("Starting Date-Time")]
        public DateTime Starting_Date_Time { get; set; }

        [Column("Ending Date-Time")]
        public DateTime Ending_Date_Time { get; set; }

        [Column("Dimension Set ID")]
        public int Dimension_Set_ID { get; set; }

        [Column("Assigned User ID")]
        
        [StringLength(50)]
        public string Assigned_User_ID { get; set; }

        [Column(TypeName = "image")]
        public byte[] Picture { get; set; }

        [Column("Prod_ Order Type")]
        public int Prod__Order_Type { get; set; }

        [Column("Metal_Fab Finish")]
        
        [StringLength(150)]
        public string Metal_Fab_Finish { get; set; }

        [Column("Timber Finish")]
        
        [StringLength(20)]
        public string Timber_Finish { get; set; }

        public decimal Length { get; set; }

        public decimal Width { get; set; }

        public decimal Height { get; set; }

        [Column("Drawing Code")]
        
        [StringLength(20)]
        public string Drawing_Code { get; set; }

        [Column("Drawing Version")]
        
        [StringLength(20)]
        public string Drawing_Version { get; set; }

        [Column("Spec_ Code")]
        
        [StringLength(20)]
        public string Spec__Code { get; set; }

        [Column("Spec_ Version")]
        
        [StringLength(20)]
        public string Spec__Version { get; set; }

        [Column("Production BOM")]
        
        [StringLength(20)]
        public string Production_BOM { get; set; }

        [Column("Packing BOM")]
        
        [StringLength(20)]
        public string Packing_BOM { get; set; }

        public int ScheduleID { get; set; }

        public int ScheduleStatus { get; set; }

        public decimal SalePrice { get; set; }

        [Column("Plan Order")]
        
        [StringLength(30)]
        public string Plan_Order { get; set; }

        
        [StringLength(20)]
        public string ParentProdNo { get; set; }
    }
}
