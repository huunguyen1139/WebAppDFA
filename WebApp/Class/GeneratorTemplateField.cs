using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace WebApplication2
{
    public class GeneratorTemplateField : ITemplate
    {
        Control control;

        public GeneratorTemplateField(Control t)
        {
            control = t;
        }

        void ITemplate.InstantiateIn(System.Web.UI.Control container)
        {
            try
            {
                container.Controls.Add(control);
            }
            catch { }
        }
    }
}