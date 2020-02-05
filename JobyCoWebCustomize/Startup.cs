using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(JobyCoWebCustomize.Startup))]
namespace JobyCoWebCustomize
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
