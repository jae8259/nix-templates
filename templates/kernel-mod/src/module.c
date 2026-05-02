#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("");
MODULE_DESCRIPTION("");

static int __init mod_init(void)
{
	pr_info("module: loaded\n");
	return 0;
}

static void __exit mod_exit(void)
{
	pr_info("module: unloaded\n");
}

module_init(mod_init);
module_exit(mod_exit);
