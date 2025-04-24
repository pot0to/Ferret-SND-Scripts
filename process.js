const fs = require("fs");
const path = require("path");

// Read CSV file
const csvFilePath = path.join(__dirname, "merged_data.csv");
const csvData = fs.readFileSync(csvFilePath, "utf-8");

// Split into lines and parse
const lines = csvData.trim().split("\n");
const headers = lines[0].split(",").slice(1); // remove the 'key' column

// Filter out metadata and type lines
const dataLines = lines.slice(3); // skip metadata and type lines

function get_mission_class(id) {
  return {
    1: "D",
    2: "C",
    3: "B",
    4: "A",
    5: "?",
    6: "??",
  }[id];
}

let output = "";
dataLines.forEach((line, rowIndex) => {
  const columns = line.split(",");
  const key = columns[0];
  const values = columns.slice(1);

  const title = values[0].replace(" ", "");
  const job_id = values[2];
  const mission_class_id = values[6];
  const mission_id = values[8];

  const recipe_count = values[26];
  const has_multiple_recipes = recipe_count > 1 ? "true" : "false";

  output += `[${mission_id}] = {` + "\n";
  output += `    name = ${title},` + "\n";
  output += `    class = "${get_mission_class(mission_class_id)}",` + "\n";
  output += `    job = ${job_id},` + "\n";
  output += `    has_multiple_recipes = ${has_multiple_recipes},` + "\n";
  output += "},\n";
});

const outputFilePath = path.join(__dirname, "output.txt");
fs.writeFileSync(outputFilePath, output, "utf-8");
