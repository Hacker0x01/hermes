#include <ruby.h>
#include <ruby/debug.h>

static int starts_with(const char *pre, const char*str);
static void add_to_buffer(const char *path);
static void call_event(VALUE trace_point, void *data);
static void register_tracepoints(VALUE self);
static void disable_tracepoints(VALUE self);
void Init_hermes(void);

/* To prevent unused parameter warnings */
#define UNUSED(x) (void)(x)
