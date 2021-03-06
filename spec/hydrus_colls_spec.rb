require 'spec_helper'

describe "Hydrus collections" do

  shared_examples_for 'hydrus collection object' do | solr_doc_id |
    it "should have display_type of file" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'file')
    end
  end
  shared_examples_for 'hydrus item object' do | solr_doc_id |
    it "should have display_type of file" do
      resp = solr_response({'qt'=>'document', 'id'=>solr_doc_id, 'fl'=>'id,display_type', 'facet'=>false})
      resp.should include('display_type' => 'file')
    end
  end

  # tests for hydrus collections
  # coll_druid: the druid of the collection object
  # num_items: the number of items in this collection
  # display_types:  the expected value(s) of SW display_type field.  Can be String or Array of Strings
  # resource_types:  the expected value(s) of SW format_main_ssim field.  Can be String or Array of Strings
  # author_missing_ids: the ids of records missing searchable author.  nil, String, or Array of Strings
  # item_query_str:  the query string to retrieve items from this collection in a SW 'everything' search
  # item_druid:  the druid of an item expected to be retrieved with the query
  # num_results:  the item druid will be found within the first (n) of the search results
  # dark_object_ids = Array of Solr ids for objects that won't have file_id
  shared_examples_for 'hydrus coll' do | coll_druid, num_items, display_types, resource_types, author_missing_ids, item_query_str, item_druid, num_results, dark_object_ids |
    it_behaves_like "all items in collection", coll_druid, num_items
    it_behaves_like "DOR collection object", coll_druid, coll_druid
    it_behaves_like "hydrus collection object", coll_druid
    it_behaves_like "DOR item objects", item_query_str, [item_druid], num_results, coll_druid, dark_object_ids
    it_behaves_like "hydrus item object", item_druid
    facet_query = "collection:#{coll_druid}"
    it_behaves_like 'expected display_type values', facet_query, display_types
    it_behaves_like 'expected format_main_ssim values', facet_query, resource_types
    it_behaves_like "date fields present", facet_query
    if author_missing_ids && author_missing_ids.size > 0
      it_behaves_like "author field present except", facet_query, author_missing_ids
    else
      it_behaves_like "author field present", facet_query
    end
    # as of 2014-03, there is no way to input language into Hydrus metadata,
    # so language can't be required until that is fixed.
#    it_behaves_like "language", facet_query
  end

  context "Big Ideas" do
    # DATA FIXME:  is format 'Other' still best fit?
    it_behaves_like 'hydrus coll', 'xf112dv1419', 74, 'file', 'Book', nil, "alix personal", 'mq607rm1165', 3
  end
  context "Center for Computer Research in Music and Acoustics" do
    it_behaves_like 'hydrus coll', 'hn807kb3349', 3, 'file', ["Book", "Archive/Manuscript"], nil, "chuck audio programming", 'jv545yc8727', 10
  end
  context "CISAC honors theses" do
    it_behaves_like 'hydrus coll', 'md903dt5665', 30, 'file', 'Book', nil, "anarchy or regulation", 'zs241cm7504', 10
  end
  context "City Nature" do
    it_behaves_like 'hydrus coll', 'zh869cy6686', 3, 'file', ['Book', 'Dataset'], nil, "naturehoods describing urban nature", 'yj038bt1548', 10
  end
  context "David Starr Jordan Papers" do
    it_behaves_like 'hydrus coll', 'jy460rb9016', 2, "file", "Archive/Manuscript", nil, "david starr jordan business correspondence", 'sw878zc4588', 10
  end
  context "Digital Humanities" do
    it_behaves_like 'hydrus coll', 'np305zs0638', 2, 'file', 'Dataset', nil, "network edge and node tables", 'mn425tz9757', 10
  end
  context "Donald Pippin" do
    it_behaves_like 'hydrus coll', 'xg598bt7576', 73, 'file', "Book", nil, "no love allowed", 'bw510pk6500', 3
  end
  context "Drosophila Antennal Lobe Synapses" do
    it_behaves_like 'hydrus coll', 'wn197rj7271', 7, 'file', "Dataset", nil, "raw images of DA1", 'yq356jk9768', 10
  end
  context "Engineering physics undergrad theses" do
    it_behaves_like 'hydrus coll', 'xv924ks7647', 3, 'file', 'Book', nil, "deduceit", 'bg823wn2892', 3
  end
  context "Engineering undergrad theses" do
    it_behaves_like 'hydrus coll', 'jg722zc0626', 41, 'file', 'Book', nil, "uclinux", 'ng517gq2855', 3
  end
  context "Folding@home" do
    it_behaves_like 'hydrus coll', 'cj269gn0736', 8, 'file', 'Dataset', nil, "hp35 trajectory data", 'bd829sf1034', 3
  end
  context "Forum on Future of Scientific Publishing" do
    it_behaves_like 'hydrus coll', 'ck552zg2217', 14, 'file', 'Book', nil, "open access to manuscripts", 'fx147cs4847', 10
  end
  context "GSE International Comparative Education Master's Monographs" do
    it_behaves_like 'hydrus coll', 'qd259nz6640', 21, 'file', 'Book', nil, "conditions of happiness", 'xr366xd9204', 10
  end
  context "GSE Open Archive" do
    it_behaves_like 'hydrus coll', 'tz959sb6952', 129, 'file', ["Book", 'Archive/Manuscript'], nil, "acculturative stress and coping", 'yg867nn1610', 5
  end
  context "H. Bruce Franklin Collection" do
    it_behaves_like 'hydrus coll', 'pn278bq2224', 11, "file", "Archive/Manuscript", nil,"Advisory Board decision in the matter of professor H. Bruce Franklin", 'cm175mf2096', 5
  end
  context "Hopkins Marine Station collection" do
    it_behaves_like 'hydrus coll', 'pn808wc6253', 9, 'file', ["Dataset", "Archive/Manuscript"], ["fp045wx3019", "gk364tm7562", "gr102xg7009", "tt999fm2734", "xp974kw7556", "yb742ts0531"], "sea anemone distribution", 'fp045wx3019', 10
  end
  context "Jane Lathrop Stanford Papers" do
    it_behaves_like 'hydrus coll', 'hs468px3695', 3, "file", "Archive/Manuscript", nil, "death and estate papers", 'fk544dk9538', 10
  end
  context "John A. Blume Earthquake Engineering Center Technical Report Series" do
    it_behaves_like 'hydrus coll', 'mz198fp9366', 166, 'file', ["Book"], ["dv756jr9637", "nh929nm1593"], "damage diagnosis algorithms", 'wg007jn8560', 5
    #it_behaves_like "language", facet_query # 157 recs missing language as of 2014-05-23
  end
  context "Leland Stanford Papers" do
    it_behaves_like 'hydrus coll', 'zx692xz8270', 4, "file", "Archive/Manuscript", nil, "leland stanford legal papers", 'kh510mt0132', 10
  end
  context "Lobell Laboratory" do
    it_behaves_like 'hydrus coll', 'rz423vt0583', 1, 'file', "Software/Multimedia", nil, "maize yield increase in the US midwest", 'tp790js7917', 5
  end
  context "Luo Lab Dorsal Raphe Tracing Images" do
    it_behaves_like 'hydrus coll', 'hq143gy3770', 1, 'file', "Dataset", nil, "rabies tracing brains", 'zs331dk1033', 5
  end
  context "Marine Biogeochemistry Data" do
    it_behaves_like 'hydrus coll', 'wg919by6182', 1, 'file', "Dataset", nil, "isotopic data from Peru", 'kw310md6771', 5
  end
  context "Martin Hellman" do
    it_behaves_like 'hydrus coll', 'rr229tn9249', 5, 'file', "Archive/Manuscript", nil, "cryptography history", 'wg115cn5068', 10
  end
  context "Martin Luther King at Stanford" do
    it_behaves_like 'hydrus coll', 'yt337pb3236', 3, "file", ["Image", "Video"], "dn923nh8281",  "martin luther king at stanford", 'dn923nh8281', 10
  end
  context "ME310 2013" do
    # DATA FIXME:  is format 'Other' still best fit?
    it_behaves_like 'hydrus coll', 'kq629sd5182', 25, 'file', ['Book', 'Other'], nil, "audievolve", 'qt429km6702', 3
  end
  context "Multimedia files for digital image processing class at stanford" do
    it_behaves_like 'hydrus coll', 'ff984ns9763', 34, 'file', ["Archive/Manuscript", "Dataset"], nil, "code for winter 2013", 'gv471dj5607', 10
  end
  context "Papers from the Gimon Conference on French Political Economy, April 2004" do
    it_behaves_like 'hydrus coll', 'nj859zd5622', 15, 'file', 'Book', nil, "the age of the code noir", 'py996pf3963', 10
  end
  context "Paul R. Ehrlich papers" do
    it_behaves_like 'hydrus coll', 'ft617pg1817', 2, 'file', ["Video", "Sound recording"], nil, "Additional Material (Accession 2005-170)", 'zp321tx2887', 10
  end
  context "Payne Paleobiology Lab Data Files" do
    it_behaves_like 'hydrus coll', 'ns899tx9783', 3, 'file', "Dataset", nil, "Metabolic dominance of bivalves", 'hs422jm3330', 5
  end
  context "Physics Undergrad Theses" do
    it_behaves_like 'hydrus coll', 'ds247vz0452', 25, 'file', "Book", nil, "scanning squid", 'gh325bb5942', 3
  end
  context "Pleistocene Lake Surprise" do
    it_behaves_like 'hydrus coll', 'wm362dj5692', 6, 'file', ['Book', 'Dataset'], nil, "Pleistocene to middle Holocene", 'cb924rw5595', 10
  end
  context "Preserving Virtual Worlds" do
    it_behaves_like 'hydrus coll', 'sn446tz2204', 8, 'file', "Software/Multimedia", ['xy157wz5444', 'rd383mp8260'], "star raiders", 'pp060nc9006', 3, ['pp060nc9006']
  end
  context "Project MKULTRA collection" do
    it_behaves_like 'hydrus coll', 'fp666pd4654', 1, 'file', "Archive/Manuscript", nil, "Project MKULTRA collection", 'xf259xw8228', 5
  end
  context "Reliability of Marine Structures Program collection" do
    it_behaves_like 'hydrus coll', 'jx221pk5832', 39, 'file', "Book", nil, "second-order random waves", 'dd539xx3473', 10
  end
  context "ReNUWIt Data Collection" do
    it_behaves_like 'hydrus coll', 'jd484mb4712', 2, 'file', "Book", nil, "onsite wastewater soil treatment units", 'sx869kz6742', 5
  end
  context "Research Datasets for Image, Video, and Multimedia Systems Group @ Stanford" do
    it_behaves_like 'hydrus coll', 'cm018rf5314', 12, 'file', ["Dataset", "Software/Multimedia"], nil, "Stanford Streaming Mobile Augmented Reality Dataset", 'ph459zk5920', 5
  end
  context "Research Datasets for MPEG" do
    it_behaves_like 'hydrus coll', 'dy168sr2794', 2, 'file', "Dataset", "qy869qz5226", "Visual Search (CDVS) Benchmark", 'qy869qz5226', 5
  end
  context "Rigler-Deutsch Computer Tapes" do
    it_behaves_like 'hydrus coll', 'jd276dz9994', 5, "file", ["Book", "Dataset", "Archive/Manuscript"], nil, "Rigler Deutsch Record Index", 'cr661vw3932', 10
  end
  context "Serial section electron microscopy data for Nanoscale organization of the MEC-4 DEG/ENaC sensory mechanotransduction channel in Caenorhabditis elegans touch receptor neurons" do
    it_behaves_like 'hydrus coll', 'cv355cw2458', 2, 'file', "Dataset", nil, "immuno electron microscopy", 'zb423jg0099', 10
  end
  context "Serial section electron microscopy data for Posttranslational acetylation of alpha tubulin constrains protofilament number in native microtubules" do
    it_behaves_like 'hydrus coll', 'sc642pw6867', 8, "file", "Dataset", nil, "touch receptor neurons", 'qg053ym5844', 10
  end
  context "Software and data produced by Baker Research Group" do
    it_behaves_like 'hydrus coll', 'qy070zf4368', 6, 'file', ["Dataset", "Software/Multimedia"], nil, "dynamic structural analysis", 'sw589ts9300', 10
  end
  context "Stanford Artificial Intelligence Laboratory Records" do
    it_behaves_like 'hydrus coll', 'jb056mm1304', 3, "file", ["Image", "Archive/Manuscript"], ["pb496bf3201", "hb976hq8639", "qz957bs6680"],  "35th reunion 2009", 'pb496bf3201', 5
  end
  context "Stanford Athletics Interviews" do
    it_behaves_like 'hydrus coll', 'zk807sw9336', 2, 'file', ['Sound recording', 'Archive/Manuscript'], ['gz839jz3577', 'pd175rf4256'], "transcripts interviews bob murphy", 'pd175rf4256', 20
  end
  context "The Stanford Flipside" do
    it_behaves_like 'hydrus coll', 'dq441rn2614', 3, "file", "Archive/Manuscript", nil, "stanford flipside 2008", 'bv723rv4628', 10
  end
  context "Stanford Geospatial Center Teaching Data" do
    it_behaves_like 'hydrus coll', 'hy561cz6360', 3, "file", "Dataset", nil, "clowns of america", 'sp780kk0063', 10
  end
  context "Stanford LGBT Alumni Oral History Interviews" do
    it_behaves_like 'hydrus coll', 'kz963xt9682', 2, 'file', ['Sound recording', 'Archive/Manuscript'], "gk352dr4264", "transcripts LGBT alumni oral history", 'gk352dr4264', 20
  end
  context "Stanford Master's Theses" do
    it_behaves_like 'hydrus coll', 'xx313vx3974', 3, 'file', 'Book', nil, "conservative christian homeschooling", 'tw648nr5460', 10
  end
  context "Stanford Project for Open Knowledge in Epidemiology (SPOKE) collection" do
    it_behaves_like 'hydrus coll', 'dm482qr7820', 3, 'file', 'Software/Multimedia', nil, "decomposition package for stata", 'gw696hj6227', 10
  end
  context "Stanford Research Data" do
    it_behaves_like 'hydrus coll', 'md919gh6774', 34, 'file', ['Dataset', 'Book', 'Video', 'Software/Multimedia'], nil, "high angular resolution", 'yx282xq2090', 3
  end
  context "Stanford Student Letters and Memoirs" do
    it_behaves_like 'hydrus coll', 'mt423yd8582', 1, "file", "Archive/Manuscript", 'jv222bg0652',  "letters and memoirs", 'jv222bg0652', 10
  end
  context "Stanford University Commencement Collection" do
    it_behaves_like 'hydrus coll', 'nz928tt4938', 3, "file", ["Archive/Manuscript", "Video"], ["xq460yy5434", "sv489yy6266", "mp840zw9344"],  "commencement addresses", 'mp840zw9344', 10
  end
  context "Stanford University Film Collection" do
    it_behaves_like 'hydrus coll', 'tm335zd3912', 1, "file", "Video", 'zv044zr8616', "stanford university film collection films 1937", 'zv044zr8616', 10
  end
  context "Stanford University Video Collection" do
    it_behaves_like 'hydrus coll', 'gn946cw3927', 1, "file", "Video", 'ts408hz9199', "stanford university videos 1939", 'ts408hz9199', 20
  end
  context "SUL staff publications" do
    it_behaves_like 'hydrus coll', 'hn730ks3626', 9, 'file', ['Book'], nil, "academy unbound", 'bd701dh8028', 3
  end
  context "Temperature variation effects on intertidal communities collection" do
    it_behaves_like 'hydrus coll', 'wj675xq3748', 1, 'file', ['Dataset'], nil, "growth rates of intertidal consumers", 'mz343tz6255', 5
  end
  context "Towards in vivo estimation of reaction kinetics using high-throughput metabolomics data: a maximum likelihood approach" do
    it_behaves_like 'hydrus coll', 'ns069zc4473', 1, 'file', ['Software/Multimedia'], nil, "MATLAB scripts", 'bg158sn4020', 5
  end
  context "Undergraduate and Graduate Theses, Department of Anthropology" do
    it_behaves_like 'hydrus coll', 'rj822rp7129', 10, "file", "Book", nil, "Destabilizing the Photograph", 'gv923cc5855', 10
  end
  context "Undergraduate Honors Theses, Department of English" do
    it_behaves_like 'hydrus coll', 'sn758bh0099', 10, "file", "Book", nil, "dialectical critique of transgression", 'tp540zr1609', 10
  end
  context "Undergraduate Honors Theses, Graduate School of Education" do
    it_behaves_like 'hydrus coll', 'qs035dj7859', 16, "file", "Book", nil, "Civic Engagement in Anakbayan", 'jw598xm2819', 3
  end
  context "Undergraduate Theses, Department of Biology, 2013-2014" do
    it_behaves_like 'hydrus coll', 'fr625dm6043', 49, "file", "Book", nil, "Ablation of Quiescent Neural Stem Cells", 'dz807gb9398', 5
  end
  context "Undergraduate Theses, Program in Feminist, Gender, and Sexuality Studies" do
    it_behaves_like 'hydrus coll', 'jr938vv9537', 7, "file", "Book", nil, "gay catholic men", 'by699sk7545', 3
  end
  context "Visitations" do
    it_behaves_like 'hydrus coll', 'nc548gj3912', 3, 'file', ['Archive/Manuscript'], nil, "theotokia", 'km857qm6697', 5
  end
  context "Vista Lab" do
    it_behaves_like 'hydrus coll', 'qd500xn1572', 9, "file", "Dataset", nil, "Asynchronous broadband signals", 'hj582pj3902', 3
  end
  context "Water in the West" do
    it_behaves_like 'hydrus coll', 'bq187rh3787', 19, "file", "Book", nil, "well runs dry", 'pt977vw1969', 10
  end
  context "Yotsuba Society Archives - 4Chan Imageboard Files" do
    it_behaves_like 'hydrus coll', 'rw352rk5082', 1, "file", "Archive/Manuscript", 'tf565pz4260', "4chan archive", 'tf565pz4260', 10
    facet_query = "collection:rw352rk5082"
    it_behaves_like "language", facet_query
  end

end
