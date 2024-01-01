/*eslint import/no-unresolved: [2, { ignore: ['^k6.*'] }]*/

import { SubjectApi } from "./libs/apis/subject";

export default  () => {
    const api = new SubjectApi("http://localhost:8888");
    api.getAllSubjects();
};
