using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Models.Enum
{
    public class ApprovalEnum
    {
        public enum ApprovalDocumentType
        {
            DomesticSiteOrder = 2,
            Drawing = 3,
            PurchaseRequest = 5,
            DomesticFactoryOrder = 6,
            ForeignFactoryOrder = 7,
            BlanketOrder = 8,
            ExceptionalOrder = 9,
            BlanketFactoryOrder = 10,
            BlanketSiteOrder = 11,

            PRICE_DomesticTenderOrder = 26,

            DomesticTenderOrder = 12,
            ForeignTenderOrder = 13,
            SampleOrder = 14,
            DomesticQSOrder = 15,
            Factory_Subcontracting_Request = 16,

            //Purchase Order
            Factory_PO = 17,
            Factory_PO_BigAmount = 18,
            Office_PO = 19,
            Office_PO_BigAmount = 20,
            Site_Subcontracting_PO = 21,

            //Purchase Requisition
            Factory_PR_Export_Production_Item = 22,
            Factory_PR_Domestic_Production_Item = 23,
            Factory_PR_Non_Production_Item_Maintenance = 24,
            Factory_PR_Non_Production_Item_Tools = 25,

            Site_Manpower_Daily_Report = 27,

        }
    }
}