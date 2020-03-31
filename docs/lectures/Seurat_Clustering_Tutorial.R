library(dplyr)
library(Seurat)
library(patchwork)

# Load the PBMC dataset
pbmc.data <- Read10X(data.dir = "~/Documents/seurat_tutorial/filtered_gene_bc_matrices/hg19/")

# Initialize the Seurat object with the raw (non-normalized data).
pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)
pbmc

# Seurat allows you to easily explore QC metrics and filter cells based on any user-defined criteria.

# The [[ operator can add columns to object metadata. This is a great place to stash QC stats
pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")

# In the example below, we visualize QC metrics, and use these to filter cells.
# Visualize QC metrics as a violin plot
VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# FeatureScatter is typically used to visualize feature-feature relationships, but can be used
# for anything calculated by the object, i.e. columns in object metadata, PC scores etc.

plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 + plot2

#Filter by thresholds
pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)


#After removing unwanted cells from the dataset, the next step is to 
#normalize the data. By default, Seurat employs a global-scaling normalization 
#method “LogNormalize” that normalizes the feature expression measurements 
#for each cell by the total expression, multiplies this by a scale factor (10,000 by default), 
#and log-transforms the result. Normalized values are stored in pbmc[["RNA"]]@data.
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000) #'pbmc <- NormalizeData(pbmc)' is equivalent


#We next calculate a subset of features that exhibit high cell-to-cell variation 
#in the dataset (i.e, they are highly expressed in some cells, and lowly expressed in others). 
#Focusing on these genes in downstream analysis helps to highlight biological signal in single-cell datasets.
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)

# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2


#Next, apply a linear transformation (‘scaling’) that is a standard pre-processing step prior to 
#dimensional reduction techniques like PCA. The ScaleData function:
#    Shifts the expression of each gene, so that the mean expression across cells is 0
#    Scales the expression of each gene, so that the variance across cells is 1
#    This step gives equal weight in downstream analyses, so that highly-expressed genes do not dominate
#    The results of this are stored in pbmc[["RNA"]]@scale.data

#Scaling Data 
all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)


#Next perform PCA on the scaled data. By default, only the previously determined 
#variable features are used as input, but can be defined using features argument if 
#you want to choose a different subset.

#Perform linear dimensional reduction
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))

# Examine and visualise PCA results a few different ways
print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)

#Dimensional Loadings
VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")

DimPlot(pbmc, reduction = "pca")

#Heatmap (especially good for visualising prominant sources of heterogeneity)
DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE)


# How about the first 15?
DimHeatmap(pbmc, dims = 1:15, cells = 500, balanced = TRUE)
    

#///////////////////Determine the ‘dimensionality’ of the dataset

# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time

#pbmc <- JackStraw(pbmc, num.replicate = 100)
#pbmc <- ScoreJackStraw(pbmc, dims = 1:20)

#The JackStrawPlot function provides a visualization tool for comparing the distribution of p-values for 
#each PC with a uniform distribution (dashed line). ‘Significant’ PCs will show a strong enrichment of 
#features with low p-values (solid curve above the dashed line). In this case it appears that there is a 
#sharp drop-off in significance after the first 10-12 PCs.
#JackStrawPlot(pbmc, dims = 1:15)

# Examine elbow plot to decide cutoff for priciple components
# Try downstream analysis with different cutoffs! How does it affect the results? 
ElbowPlot(pbmc)

#Clustering 
#KNN with edge weights refined by Jaccard similarity (shared overlap of local nearest neighbours).
#   clusters can be found using the Idents() function.
pbmc <- FindNeighbors(pbmc, dims = 1:10)
pbmc <- FindClusters(pbmc, resolution = 0.5)


# Look at cluster IDs of the first 5 cells
head(Idents(pbmc), 5)

#Run non-linear dimensional reduction (UMAP/tSNE) using the same PCs as input to the clustering analysis.
# If you haven't installed UMAP, you can do so via reticulate::py_install(packages ='umap-learn')
pbmc <- RunUMAP(pbmc, dims = 1:10)

# note that you can set `label = TRUE` or use the LabelClusters function to help label
# individual clusters
DimPlot(pbmc, reduction = "umap")

#////////////Finding differentially expressed features (cluster biomarkers)

#Seurat can help you find markers that define clusters via differential 
#expression. By default, it identifes positive and negative markers of a 
#single cluster (specified in ident.1), compared to all other cells. 
#FindAllMarkers automates this process for all clusters, but you can also 
#test groups of clusters vs. each other, or against all cells.


# find all markers of cluster 1 (global comparison)
cluster1.markers <- FindMarkers(pbmc, ident.1 = 1, min.pct = 0.25)
head(cluster1.markers, n = 5)

# find all markers distinguishing cluster 5 from clusters 0 and 3
cluster5.markers <- FindMarkers(pbmc, ident.1 = 5, ident.2 = c(0, 3), min.pct = 0.25)
head(cluster5.markers, n = 5)

# find markers for every cluster compared to all remaining cells, report only the positive ones
pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
pbmc.markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_logFC)

cluster1.markers <- FindMarkers(pbmc, ident.1 = 0, logfc.threshold = 0.25, test.use = "roc", only.pos = TRUE)



#Visualise marker expression
VlnPlot(pbmc, features = c("MS4A1", "CD79A"))

# you can plot raw counts as well
VlnPlot(pbmc, features = c("NKG7", "PF4"), slot = "counts", log = TRUE)

#Visualise expression of individual genes accross clusters 
FeaturePlot(pbmc, features = c("MS4A1", "GNLY", "CD3E", "CD14", "FCER1A", "FCGR3A", "LYZ", "PPBP", "CD8A"))

#^^also try exploring RidgePlot, CellScatter, and DotPlot as additional methods to view your dataset.

#Plot the top 20 markers for each cluster
top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
DoHeatmap(pbmc, features = top10$gene) + NoLegend()

#///////////Assigning cell type identity to clusters

new.cluster.ids <- c("Naive CD4 T", "Memory CD4 T", "CD14+ Mono", "B", "CD8 T", "FCGR3A+ Mono", 
                     "NK", "DC", "Platelet")
names(new.cluster.ids) <- levels(pbmc)
pbmc <- RenameIdents(pbmc, new.cluster.ids)
DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()


#///////// Save data as r data structure to avoid recomputing objects
saveRDS(pbmc, file = "pbmc3k_final.rds")
