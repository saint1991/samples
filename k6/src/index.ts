/*eslint import/no-unresolved: [2, { ignore: ['^k6.*'] }]*/

import { SubjectApi } from "./libs/apis/subject.ts";

export default () => {
	const api = new SubjectApi("http://localhost:8888");
	api.createSubject("新しいサブジェクト");
};
