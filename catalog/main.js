const fs = require("fs");

// Convert string from any base to decimal (BigInt)
function toDecimal(value, base) {
    return BigInt(parseInt(value, base));
}

// Multiply polynomial by (x - root)
function multiplyPolynomial(poly, root) {
    let newPoly = Array(poly.length + 1).fill(0n);
    for (let i = 0; i < poly.length; i++) {
        newPoly[i] += poly[i];
        newPoly[i + 1] += -root * poly[i];
    }
    return newPoly;
}

// Solve polynomial from JSON file
function solvePolynomialFromFile(filename) {
    const rawData = fs.readFileSync(filename, "utf-8");
    const data = JSON.parse(rawData);

    const n = data.keys.n;
    const k = data.keys.k;

    // Convert all roots to decimal
    let roots = [];
    for (let key in data) {
        if (key === "keys") continue;
        let base = parseInt(data[key].base);
        let value = data[key].value;
        roots.push(toDecimal(value, base));
    }

    // Take first k roots
    let selectedRoots = roots.slice(0, k);

    // Build polynomial step by step
    let poly = [1n];
    for (let root of selectedRoots) {
        poly = multiplyPolynomial(poly, root);
    }

    // Return coefficients as strings
    return poly.slice().reverse().map(c => c.toString());
}

// ------------------ RUN BOTH TEST CASES ------------------ //
const result = {
    sample1: solvePolynomialFromFile("sample1.json"),
    sample2: solvePolynomialFromFile("sample2.json")
};

// Save output to file
fs.writeFileSync("output.json", JSON.stringify(result, null, 2), "utf-8");

console.log("✅ Output written to output.json");
