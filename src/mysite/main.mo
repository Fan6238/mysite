import Array "mo:base/Array";
actor Counter {
    func quicksort(a : [var Int]) : [var Int] {
        var i = 0;
        while (i < a.size()) {
            var j = 1;
            while (j < a.size()) {
                if (a[j -1] > a[j]) {
                    let n = a[j -1];
                    a[j - 1] := a[j];
                    a[j] := n;
                };
                j := j + 1;
            };
            i := i + 1;
        };
        return a;
    };
    public func qsort(arr : [Int]) : async [Int] {
        Array.freeze(quicksort(Array.thaw(arr))); 
    };
}