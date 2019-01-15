module dane.app;

import std.stdio;
import std.string;
import std.array;
import std.algorithm;
import mpi;
import mpi.util;

int main(string[] args)//int argc, char* argv[])
{
    int argc = cast(int)args.length;
    auto argv = args.toArgv();

    int rank;
    int size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("Hello, world, I am %d of %d\n", rank+1, size);
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Finalize();

    return 0;
}
