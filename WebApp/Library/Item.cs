using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SQRFunctionLibrary;
using System.Data;

namespace WebApplication2
{
    public partial class Item
    {
        
        public Item(string ItemCode)
        {
            try
            {
                Code = ItemCode;
                string sql = "";
                sql += " select No_, Description, [Production BOM No_], [Drawing Code], [Drawing Version Code] ";
                sql += ", (select [Description] from [LIVE_ALLIANCE_90$Leg Finish] as b where b.Code = a.[Legs Finish]) as [Legs Finish]";
                sql += ", (select [Description] from [LIVE_ALLIANCE_90$Timber Finish] as b where b.Code = a.[Timber Finish]) as [Timber Finish]";
                sql += ", format(Length,'#0.#') as [Length], format(Width,'#0.#') as Width, format(Height, '#0.#') as Height ";
                sql += " from [LIVE_ALLIANCE_90$Item] as a where No_ = @ItemCode";
                dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@ItemCode" }, new List<object>() { ItemCode });
            }
            catch { };
        }
        public DataTable dt;

        public string Code
        {
            get;           
        }
        public string DrawingCode
        {
            get { return dt.Rows[0]["Drawing Code"].ToString(); }
        }
        public string DrawingVersion
        {
            get { return dt.Rows[0]["Drawing Version Code"].ToString(); }
        }

        public string Name
        {
            get { return dt.Rows[0]["Description"].ToString(); }
        }

        public string Length
        {
            get { return dt.Rows[0]["Length"].ToString(); }
        }

        public string Width
        {
            get { return dt.Rows[0]["Width"].ToString(); }
        }

        public string Height
        {
            get { return dt.Rows[0]["Height"].ToString(); }
        }
        public string TimberFinish
        {
            get { return dt.Rows[0]["Timber Finish"].ToString(); }
        }
        public string LegsFinish
        {
            get { return dt.Rows[0]["Legs Finish"].ToString(); }
        }

        public string ProductionBOM
        {
            get { return dt.Rows[0]["Production BOM No_"].ToString(); }
        }

    }
}