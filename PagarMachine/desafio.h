/* Desafio Mobile
 * (c) 2017 Pagar.me */

typedef void (*pm_callback)(int operation, unsigned char *data, unsigned int length);

void pm_register_callback(pm_callback cb);
void pm_exec(int operation, unsigned char *data, unsigned int length);
