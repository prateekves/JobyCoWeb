using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(JobyCoWeb.Startup))]
namespace JobyCoWeb
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
