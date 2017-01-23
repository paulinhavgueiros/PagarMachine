/* Desafio Mobile
 * (c) 2017 Pagar.me */

/*!
 * @discussion Pointer to callback function from libdesafio
 * @param operation The return code
 * @param data Aditional information on the return code
 * @param length The length of the data object
 */
typedef void (*pm_callback)(int operation, unsigned char *data, unsigned int length);

/*!
 * @discussion Function used to register callback from transactions executed on libdesafio
 * @param cb Pointer to callback function
 */
void pm_register_callback(pm_callback cb);

/*!
 * @discussion Function used to execute operation on libdesafio
 * @param operation The requested transaction to execute
 * @param data The string corresponding to prefix "MAKE" followed by to amount in cents to execute operation on
 * @param length The length of the data object
 */
void pm_exec(int operation, unsigned char *data, unsigned int length);
