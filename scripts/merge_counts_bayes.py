import sys
import pandas as pd


if len(sys.argv) != 3:
    print("python {0} counts.csv bayes.out.csv".format(sys.argv[0]))
    sys.exit(1)


def merge_counts_bayes():
    """Merge both CSVs using pandas"""
    counts = pd.read_csv(sys.argv[1])
    bayes  = pd.read_csv(sys.argv[2])
    df = pd.merge(counts, bayes)
    output = sys.argv[1].split(".csv")[0]
    df.to_csv(output + "_counts_bayes.csv", index=False)


if __name__ == "__main__":
    merge_counts_bayes()
