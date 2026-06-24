#define pr_fmt(fmt) "lkp: " fmt

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("jae8259");
MODULE_DESCRIPTION("LKP: Description of your module"');

static int __init mod_init(void)
{
  pr_info("module loaded\n");
  return 0;
}

static void __exit mod_exit(void)
{
  pr_info("module unloaded\n"); /* prints: "Ikp: module loaded" */
}

module_init(mod_init);
module_exit(mod_exit);
