
#include "dmos.h"
#include "dmutil.h"
#include "dmtypes.h"
#include "dmformat.h"

int main( int argc, char* argv[] ) {
	std::cout << fmt::format("{0} {1}", "hello world! ", DMFormatDateTime());
    return 0;
}
